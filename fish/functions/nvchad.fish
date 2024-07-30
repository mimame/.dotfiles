function nvchad
    set -x NVIM_APPNAME nvchad
    if test -z "$argv"
        nvim
    else
        nvim "$argv"
    end
end
