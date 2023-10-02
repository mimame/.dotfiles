# cb STRING to copy to the clipboard
# cb FILE to copy to the clipboard
# echo string | cb to copy to the clipboard
# cb to paste from the clipboard
# cb | command to paste from the clipboad
function cb
    # stdin is a pipe
    # https://github.com/fish-shell/fish-shell/issues/3792#issuecomment-276206686
    # stdin -> clipboard
    if command test -p /dev/stdin
        set -l stdin_list
        while read line
            set stdin_list $stdin_list $line
        end
        wl-copy $stdin_list
    # stdin is not a pipe
    else if ! test -z "$argv[1]"
        # file -> clipboard
        if test -f "$argv[1]"
            wl-copy < "$argv[1]"
        # string -> clipboard
        else
            wl-copy "$argv"
        end
    else
        # clipboard -> stdout
        # no arguments were passed
        # wl-paste
    end
    wl-paste
end
