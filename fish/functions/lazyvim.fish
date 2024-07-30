function lazyvim
    set -x NVIM_APPNAME lazyvim
    if test -z "$argv"
        nvim
    else
        nvim "$argv"
    end
end
