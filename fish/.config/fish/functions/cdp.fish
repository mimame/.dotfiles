# cd to the clipboard path
function cdp
    set clipboard_path (xclip -out)
    echo "$clipboard_path"
    if test -d "$clipboard_path"
        cd "$clipboard_path"
    end
    cd "$clipboard_path"
end
