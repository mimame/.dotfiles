function normalize_string
    # Usage: normalize_string <input_string> [replacement_char]
    set -l input_string $argv[1]
    set -l replacement_char -
    if test (count $argv) -gt 1
        set replacement_char $argv[2]
    end

    set -l output_string (echo $input_string | iconv -f UTF-8 -t ASCII//TRANSLIT | tr -d '[:punct:]' | sed 's/ /'$replacement_char'/g')
    echo $output_string
end
