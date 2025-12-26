# o function - A wrapper around system openers (open/xdg-open)
# Usage: o [file|directory|url] ...
# If no arguments are provided, it tries to open the current directory with 'y' (Yazi) or the system opener.
function o --description "Open files or directories with the default system application"
    # 1. Determine the opener command based on OS
    set -l opener
    if test (uname) = Darwin
        set opener open
    else if command -q xdg-open
        set opener xdg-open
    else
        set_color red
        echo "Error: 'xdg-open' is not installed." >&2
        set_color normal
        return 1
    end

    # 2. Handle empty arguments (open current directory)
    if test (count $argv) -eq 0
        # Prefer 'y' (Yazi wrapper) if available, otherwise fallback to system opener
        if functions -q y
            y .
        else
            $opener .
        end
        return
    end

    # 3. Process arguments
    set -l opened_count 0
    for target in $argv
        # Check if target exists or is a valid URI (e.g., https://, magnet:?)
        # Regex matches standard URI schemes: starts with alpha, followed by alpha/num/+/-/., then ://
        if test -e "$target"; or string match -rq '^[a-zA-Z][a-zA-Z0-9+.-]*://' -- "$target"
            if test "$opener" = open
                # macOS 'open' usually handles backgrounding well
                $opener "$target"
            else
                # Linux 'xdg-open' needs explicit backgrounding and disowning to avoid hanging the shell
                $opener "$target" >/dev/null 2>&1 &
                disown
            end
            set opened_count (math $opened_count + 1)
        else
            set_color red
            echo "Error: '$target' does not exist." >&2
            set_color normal
        end
    end

    # 4. Provide summary feedback
    if test $opened_count -gt 0
        set -l label item
        test $opened_count -gt 1; and set label items
        echo "Opened $opened_count $label"
    end
end
