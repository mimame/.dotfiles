function t --description "Translate text to Spanish (default) and copy to clipboard"
    if test (count $argv) -eq 0
        echo "Usage: t <text...>"
        echo "Options:"
        echo "  -l <lang>  Translate to a specific language (default: :es)"
        return 1
    end

    if not command -q trans
        echo "Error: 'trans' (Translate Shell) is not installed." >&2
        return 1
    end

    set -l target_lang ":es"
    set -l text_to_translate

    # Parse arguments
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -l --lang
                set i (math $i + 1)
                set target_lang $argv[$i]
            case '*'
                set -a text_to_translate $argv[$i]
        end
        set i (math $i + 1)
    end

    if test -z "$text_to_translate"
        echo "Error: No text provided for translation." >&2
        return 1
    end

    set -l joined_text (string join " " -- $text_to_translate)
    echo "🌐 Translating to $target_lang..." >&2

    # Perform translation
    # -brief: simplified output
    # -no-ansi: strip colors for easier parsing/copying
    set -l translation (command trans -brief -no-ansi "$target_lang" "$joined_text" | string collect | string trim)

    if test -n "$translation"
        echo "✓ Result: $translation"
        printf "%s" "$translation" | cb
    else
        echo "❌ Translation failed." >&2
        return 1
    end
end
