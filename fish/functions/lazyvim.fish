function lazyvim
    set -x NVIM_APPNAME lazyvim
    if test (count $argv) -eq 0
        nvim
    else
        nvim "$argv"
    end
end
