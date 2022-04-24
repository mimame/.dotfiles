function python
    #   # stdin is a pipe
    if command test -p /dev/stdin
        command python "$argv"
    else
        # Use command to avoid the recursion
        test -z "$argv" && ptpython || command python "$argv"
    end
end
