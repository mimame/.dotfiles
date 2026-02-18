function o --description "Open files or directories with the default system application"
    set -l opener

    if $IS_DARWIN
        set opener open
    else if command -q xdg-open
        set opener xdg-open
    else
        echo "Error: No system opener (open or xdg-open) found." >&2
        return 1
    end

    # Case 1: No arguments -> Open current directory
    if test (count $argv) -eq 0
        if functions -q y
            y .
        else
            $opener .
        end
        return
    end

    # Case 2: Process multiple targets
    set -l opened 0
    for target in $argv
        # Check if it's an existing path or a valid URI
        if test -e "$target"; or string match -rq '^[a-zA-Z][a-zA-Z0-9+.-]*://' -- "$target"
            if $IS_DARWIN
                $opener "$target"
            else
                $opener "$target" >/dev/null 2>&1 &
                disown
            end
            set opened (math $opened + 1)
        else
            echo "Error: '$target' is not a valid file or URI" >&2
        end
    end

    # Provide summary if multiple items were opened and we are in an interactive shell
    if test $opened -gt 1; and status is-interactive
        echo "✓ Opened $opened items"
    end
end
