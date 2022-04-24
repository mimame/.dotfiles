function te
    # Use command to avoid recursion
    # Use "$*" instead -join-sentence "$@"
    # Remove spaces at beginning of the translated input
    # Copy the translated input to the system clipboard
    # command trans -brief -no-ansi ':es' "$argv" |
    command trans -brief -no-ansi "$argv" | tail --lines 1 | sed 's/^\s*//' # | cb
end
