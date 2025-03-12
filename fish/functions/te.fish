function te --description "Translate text using trans command"
    if test (count $argv) -eq 0
        echo "Usage: te [source:target] text" >&2
        echo "Example: te :es hello" >&2
        return 1
    end

    trans -brief -no-ansi "$argv" |
        tail --lines 1 |
        string trim |
        tee /dev/stderr | # Show result in the terminal
        cb
end
