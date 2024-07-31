function nvchad
    set -x NVIM_APPNAME nvchad
    if test (count $argv) -eq 0
        nvim
    else
        nvim "$argv"
    end
end
