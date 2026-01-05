function t --description "Translate text and copy to clipboard"
    if test (count $argv) -eq 0
        echo "Usage: t [lang_spec] <text...>"
        echo "Example: t hello          (Translates to Spanish by default)"
        echo "Example: t :en hola       (Translates to English)"
        echo "Example: t en:fr hello    (Translates English to French)"
        return 1
    end

    if not command -q trans
        echo "Error: 'trans' (Translate Shell) is not installed." >&2
        return 1
    end

    set -l target_lang ":es" # Default
    set -l text_start_index 1

    # Check if the first argument is a language specification (e.g., :en or en:es)
    if string match -qr '^[a-z]{0,2}:[a-z]{2}$' -- "$argv[1]"
        set target_lang $argv[1]
        set text_start_index 2
    end

    set -l text_to_translate $argv[$text_start_index..-1]

    if test -z "$text_to_translate"
        echo "Error: No text provided for translation." >&2
        return 1
    end

    set -l joined_text (string join " " -- $text_to_translate)
    echo "🌐 Translating to $target_lang..." >&2

    # Perform translation
    set -l translation (command trans -brief -no-ansi "$target_lang" "$joined_text" | string collect | string trim)

    if test -n "$translation"
        echo "✓ Result: $translation"
        printf "%s" "$translation" | cb
    else
        echo "❌ Translation failed." >&2
        return 1
    end
end
