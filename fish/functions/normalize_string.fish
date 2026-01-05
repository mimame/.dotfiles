function normalize_string --description "Normalize a string (slugify) by removing special characters"
    if test (count $argv) -eq 0
        echo "Usage: normalize_string <input_string> [replacement_char]" >&2
        return 1
    end

    set -l input_string $argv[1]
    set -l replacement_char -

    if test (count $argv) -gt 1
        set replacement_char $argv[2]
    end

    if test -z "$input_string"
        return 0
    end

    # 1. Convert to lowercase first to simplify replacements
    set -l output (string lower "$input_string")

    # 2. Manual transliteration for common diacritics to bypass unreliable iconv behavior on some systems (macOS)
    set output (string replace -ra '[àáâãäå]' 'a' "$output" |
                string replace -ra '[èéêë]' 'e' |
                string replace -ra '[ìíîï]' 'i' |
                string replace -ra '[òóôõö]' 'o' |
                string replace -ra '[ùúûü]' 'u' |
                string replace -ra '[ñ]' 'n' |
                string replace -ra '[ç]' 'c')

    # 3. Transliterate remaining characters to ASCII (e.g., ł -> l)
    # BSD iconv (macOS) often returns 1 even on success; we use the output if non-empty.
    set -l transliterated (printf "%s" "$output" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null)
    if test -n "$transliterated"
        set output "$transliterated"
    end

    # 4. Remove common transliteration marks (' " ^ ~ `) that BSD iconv might have added
    set output (string replace -ra "['\"^~`]" "" "$output")

    # 5. Replace all remaining non-alphanumeric sequences with the replacement character
    set output (string replace -ra '[^a-z0-9]+' "$replacement_char" "$output")

    # 6. Trim replacement characters from the ends
    set output (string trim -c "$replacement_char" "$output")

    echo "$output"
end
