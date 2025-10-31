#!/usr/bin/env fish
#
# Rofi File Finder
#
# A Rofi script mode that uses `fd` to find files and `xdg-open` to open them.
#
# When text is entered in Rofi, this script calls `fd` to search for files
# matching the text within the /home and /tmp directories.
#
# When a file is selected from the list, this script uses `xdg-open` to open
# it with its default registered application.

# Rofi passes the currently selected line or typed text as an argument.
if count $argv >0
    set QUERY "$argv"

    # If the argument is an absolute path, it's a selected file/folder. Open it.
    if string match -q "/*" "$QUERY"
        xdg-open "$QUERY" >/dev/null 2>&1 &
        exit
    else
        # Otherwise, it's search text. Use fd to find matching files.
        fd --exclude node_modules --exclude .cache --exclude target --exclude __pycache__ --exclude vendor --exclude .var/app --exclude .git "$QUERY" /home /tmp
    end
end
