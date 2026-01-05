function cdp --description "Change directory to the path in clipboard"
    set -l raw_path (cb)

    if test -z "$raw_path"
        echo "Error: Clipboard is empty" >&2
        return 1
    end

    # Trim whitespace and quotes that might be copied along with the path
    set -l target (string trim -c " '\"" "$raw_path")

    # Safely expand tilde (~/path -> /home/user/path)
    # This avoids 'eval' which is prone to command injection.
    set target (string replace -r '^~($|/)' "$HOME\$1" "$target")

    # Resolve to absolute path if possible
    set -l resolved (path resolve "$target" 2>/dev/null; or echo "$target")

    if test -d "$resolved"
        if test "$resolved" = "$PWD"
            echo "Already in $resolved"
            return 0
        end
        cd "$resolved"
        echo "Entered: $PWD"
    else if test -f "$resolved"
        set -l parent (path dirname "$resolved")
        if test "$parent" = "$PWD"
            echo "Already in parent directory of $resolved"
            return 0
        end

        read -P "Path is a file. Change to parent directory '$parent'? [y/N] " confirm
        if string match -qi "y*" -- "$confirm"
            cd "$parent"
            echo "Entered: $PWD"
        else
            echo Cancelled >&2
            return 1
        end
    else
        echo "Error: Not a valid directory or file: '$target'" >&2
        return 1
    end
end
