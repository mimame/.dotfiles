function R
    # stdin is a pipe
    if command test -p /dev/stdin
        command R "$argv"
    else
        # Use command to avoid the recursion
        test -z "$argv" && radian || command R "$argv"
    end
end
