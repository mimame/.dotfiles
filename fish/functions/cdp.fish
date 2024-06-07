# cd to the path stored in the clipboard
function cdp
    # Store the clipboard content in a variable
    set clipboard_path (wl-paste)

    # Check if the clipboard contains a valid directory path
    if test -d "$clipboard_path"
        # Change directory to the clipboard path
        cd "$clipboard_path"
    else
        # Print an error message if the clipboard does not contain a valid directory path
        echo "Clipboard does not contain a valid directory path"
    end
end
