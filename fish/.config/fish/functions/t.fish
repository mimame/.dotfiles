function t
    # Use command to avoid recursion
    # Remove spaces at beginning of the translated input
    # Copy the translated input to the system clipboard
    command trans -brief -no-ansi :es "$argv" | tail --lines 1 | sed 's/^\s*//' | cb
end
