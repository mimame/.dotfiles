function t --description "Translate text to Spanish and copy to clipboard"
    if test (count $argv) -eq 0
        echo "Usage: t [text to translate]"
        return 1
    end

    # Use command to avoid recursion
    # Process the translation: trim whitespace and copy to clipboard
    command trans -brief -no-ansi :es "$argv" |
        tail --lines 1 |
        string trim |
        tee /dev/stderr | # Show result in terminal
        cb
end
