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
function cb
    # Determine the appropriate copy and paste commands based on the OS
    set copy_command (if test (uname) = Darwin; echo pbcopy; else; echo wl-copy; end)
    set paste_command (if test (uname) = Darwin; echo pbpaste; else; echo wl-paste; end)

    # If stdin is a pipe, read from stdin and copy to clipboard
    # https://github.com/fish-shell/fish-shell/issues/3792#issuecomment-276206686
    if command test -p /dev/stdin
        cat - | $copy_command
        # If arguments are provided, check if it's a file or a string
    else if set -q argv[1]
        # If the first argument is a file, copy its contents to the clipboard
        if test -f "$argv[1]"
            cat "$argv[1]" | $copy_command
            # Otherwise, treat the arguments as a string and copy to the clipboard
        else
            echo -n $argv | $copy_command
        end
        # If no arguments and not a pipe, paste from clipboard to stdout
    else
        $paste_command
    end
end
