# cd to the path stored in the clipboard
function cdp --description "Change directory to the path in clipboard"
    # Store the clipboard content in a variable
    set -l clipboard_path (cb)

    # Handle empty clipboard
    if test -z "$clipboard_path"
        echo "Error: Clipboard is empty" >&2
        return 1
    end

    # Trim whitespace from clipboard path
    set -l trimmed_path (string trim "$clipboard_path")

    # Expand the tilde and environment variables if present in the path
    set -l expanded_path (eval echo $trimmed_path)

    # Check if the clipboard contains a valid directory path
    if test -d "$expanded_path"
        # Change directory to the clipboard path and display confirmation
        cd "$expanded_path"
        echo "Changed directory to: $expanded_path"
    else
        # Check if it's a file path and offer to cd to its directory
        if test -f "$expanded_path"
            set -l parent_dir (dirname "$expanded_path")
            read -P "Path is a file. Change to parent directory '$parent_dir'? [y/N] " confirm

            if test "$confirm" = y -o "$confirm" = Y
                cd "$parent_dir"
                echo "Changed directory to: $parent_dir"
            else
                echo "Operation cancelled" >&2
                return 1
            end
        else
            # Print an error message if the clipboard does not contain a valid path
            echo "Error: Clipboard does not contain a valid directory path: '$expanded_path'" >&2
            return 1
        end
    end
end
