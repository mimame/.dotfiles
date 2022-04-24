# cb STRING to copy to the clipboard
# cb FILE to copy to the clipboard
# echo string | cb to copy to the clipboard
# cb to paste from the clipboard
# cb | command to paste from the clipboad
function cb
    # stdin is a pipe
    # https://github.com/fish-shell/fish-shell/issues/3792#issuecomment-276206686
    if command test -p /dev/stdin
        # stdin -> clipboard
        xclip -selection clipboard -in
        # stdin is not a pipe
    else if ! test -z "$argv[1]"
        if test -f "$argv[1]"
            # file -> clipboard
            xclip -selection clipboard -in "$argv[1]"
        else
            echo "STRING!!!"
            # string -> clipboard
            echo "$argv" | xclip -selection clipboard -in
        end
    else
        # clipboard -> stdout
        # no arguments were passed
        # xclip -selection clipboard -out
    end
    xclip -selection clipboard -out
end
