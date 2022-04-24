# # o function and open function with handlr {{{
# # It works better than xdg-open in i3-wm and also it provides a better and nicer terminal interface than their xdg-utils equivalents
function o
    if test (count $argv) -eq 0
        vifm .
    else
        # handlr can open multiple files at the same time without the explict loop
        # but with a loop it's better to set nohup each std and err outputs independently
        # to check faster if a file is not running fine
        for file in "$argv"
            # Run handlr with nohup in background and remove it from the jobs table
            handlr open "$file" 2>/dev/null &
            disown
        end
    end
end
