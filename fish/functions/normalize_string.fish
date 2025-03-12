function normalize_string --description "Normalize a string by removing special characters and replacing spaces"
    # Check if arguments are provided
    if test (count $argv) -eq 0
        echo "Usage: normalize_string <input_string> [replacement_char]" >&2
        return 1
    end

    # Set variables with descriptive names
    set -l input_string $argv[1]
    set -l replacement_char -

    # Allow custom replacement character as second argument
    if test (count $argv) -gt 1
        set replacement_char $argv[2]
    end

    # Handle empty input gracefully
    if test -z "$input_string"
        echo ""
        return 0
    end

    # Process string: convert to ASCII, remove punctuation, replace spaces
    # Use printf instead of echo for more consistent behavior across systems
    set -l output_string (printf "%s" "$input_string" |
                         iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null |
                         tr -d '[:punct:]' |
                         tr '[:upper:]' '[:lower:]' |
                         sed 's/[[:space:]]/'$replacement_char'/g' |
                         sed 's/'$replacement_char$replacement_char'+/'$replacement_char'/g')

    # Remove leading/trailing replacement characters
    set output_string (string trim -c "$replacement_char" "$output_string")

    echo "$output_string"
end
