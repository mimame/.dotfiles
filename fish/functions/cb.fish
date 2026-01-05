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
# or 'wl-copy', 'xclip', or 'xsel' on Linux depending on the environment (Wayland/X11).
function cb --description "Universal clipboard utility for macOS and Linux"
    set -l copy_cmd
    set -l paste_cmd

    # Detect clipboard tools and set commands as arrays
    if test (uname) = Darwin
        set copy_cmd pbcopy
        set paste_cmd pbpaste
    else if set -q WAYLAND_DISPLAY; and command -q wl-copy
        set copy_cmd wl-copy
        set paste_cmd wl-paste -n
    else if command -q xclip
        set copy_cmd xclip -selection clipboard
        set paste_cmd xclip -selection clipboard -o
    else if command -q xsel
        set copy_cmd xsel --clipboard --input
        set paste_cmd xsel --clipboard --output
    else
        echo "Error: No clipboard tool found (pbcopy, wl-copy, xclip, or xsel)" >&2
        return 1
    end

    # Case 1: Read from stdin (pipe)
    if not isatty stdin
        $copy_cmd
        echo "✓ Copied from stdin to clipboard" >&2

        # Case 2: Arguments provided
    else if set -q argv[1]
        # If it's exactly one argument and it's a file, copy its content
        if test (count $argv) -eq 1; and test -f "$argv[1]"
            $copy_cmd <"$argv[1]"
            echo "✓ Copied contents of '$argv[1]' to clipboard" >&2
        else
            # Otherwise, copy the arguments joined by spaces
            echo -n "$argv" | $copy_cmd
            echo "✓ Copied text to clipboard" >&2
        end

        # Case 3: No arguments, not a pipe -> Paste
    else
        # Run paste command
        if not $paste_cmd
            echo "Error: Clipboard is empty or tool failed" >&2
            return 1
        end
    end
end
