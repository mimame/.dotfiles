# o function and open function with handlr
# It works better than xdg-open and also it provides a better and nicer terminal interface than their xdg-utils equivalents
function o --description "Open files/directories with their default applications using xdg-open"
    if test (count $argv) -eq 0
        y .
    else
        set -l opened 0
        for file in $argv
            # Check if file exists (or is a valid URI)
            if test -e "$file"; or string match -rq '^[a-zA-Z]+://' "$file"
                # Run xdg-open in the background and disown it to prevent the shell from hanging.
                xdg-open "$file" >/dev/null 2>&1 &
                disown
                set opened (math $opened + 1)
            else
                echo "Error: '$file' does not exist" >&2
            end
        end

        # Provide feedback about how many files were opened
        if test $opened -gt 0
            test $opened -eq 1 && echo "Opened 1 item" || echo "Opened $opened items"
        end
    end
end
