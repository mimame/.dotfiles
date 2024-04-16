function copy_to_clipboard
    if test (uname) = Darwin
        pbcopy
    else
        wl-copy
    end
end
