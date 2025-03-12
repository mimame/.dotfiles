# The 'cb' function is a versatile clipboard utility that adapts to both macOS and Linux environments.
# It can be used in the following ways:
#
# - `cb STRING`: Copies the provided string to the clipboard.
# - `cb FILE`: Copies the contents of the specified file to the clipboard.
# - `echo STRING | cb`: Pipes a string into 'cb', copying it to the clipboard.
# - `cb`: Outputs the current contents of the clipboard to stdout.
# - `cb | COMMAND`: Pastes the contents of the clipboard into another command.
#
# The function automatically detects the operating system and uses 'pbcopy' and 'pbpaste' on macOS,
# or 'wl-copy' and 'wl-paste' on Linux with Wayland.
function cb --description "Universal clipboard utility for macOS and Linux"
    # Determine the appropriate copy and paste commands based on environment
    set -l os (uname)

    if test "$os" = Darwin
        set copy_command pbcopy
        set paste_command pbpaste
    else
        set copy_command wl-copy
        set paste_command "wl-paste -n" # Avoid adding newline
    end

    # If stdin is a pipe, read from stdin and copy to clipboard
    if command test -p /dev/stdin
        cat - | eval $copy_command
        echo "✓ Copied from stdin to clipboard" >&2
        # If arguments are provided, check if it's a file or a string
    else if set -q argv[1]
        # If the first argument is a file, copy its contents to the clipboard
        if test -f "$argv[1]"
            cat "$argv[1]" | eval $copy_command
            echo "✓ Copied contents of '$argv[1]' to clipboard" >&2
            # Otherwise, treat the arguments as a string and copy to the clipboard
        else
            printf "%s" "$argv" | eval $copy_command
            echo "✓ Copied text to clipboard" >&2
        end
        # If no arguments and not a pipe, paste from clipboard to stdout
    else
        # Check if clipboard has content
        if eval $paste_command >/dev/null 2>&1
            eval $paste_command
        else
            echo "Error: Clipboard is empty" >&2
            return 1
        end
    end
end
