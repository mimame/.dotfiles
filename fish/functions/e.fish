function e --description "Extract various archive and compressed files"
    if test (count $argv) -eq 0
        echo "Usage: e <file...>"
        echo "Supported formats: tar, zip, 7z, rar, gz, xz, bz2, bz3, zst, and combinations (tar.gz, etc.)"
        return 1
    end

    for file in $argv
        if not test -f "$file"
            echo "Error: '$file' not found or not a regular file" >&2
            continue
        end

        set -l filename (path basename "$file")
        echo "📦 Extracting: $filename"

        switch $filename
            case '*.tar.gz' '*.tgz'
                if command -q pigz
                    pigz -dc "$file" | tar -xf -
                else
                    tar -xzf "$file"
                end
            case '*.tar.xz' '*.txz'
                if command -q pixz
                    pixz -dc "$file" | tar -xf -
                else
                    tar -xJf "$file"
                end
            case '*.tar.bz2' '*.tbz2'
                if command -q pbzip2
                    pbzip2 -dc "$file" | tar -xf -
                else
                    tar -xjf "$file"
                end
            case '*.tar.bz3' '*.tbz3'
                if command -q bzip3
                    bzip3 -dc "$file" | tar -xf -
                else
                    echo "Error: bzip3 not installed" >&2
                    continue
                end
            case '*.tar.zst' '*.tzst'
                if command -q zstd
                    zstd -dc "$file" | tar -xf -
                else
                    echo "Error: zstd not installed" >&2
                    continue
                end
            case '*.tar'
                tar -xf "$file"

            case '*.gz'
                if command -q pigz
                    pigz -dk "$file"
                else
                    gzip -dk "$file"
                end
            case '*.xz'
                if command -q pixz
                    pixz -dk "$file"
                else
                    xz -dk "$file"
                end
            case '*.bz2'
                if command -q pbzip2
                    pbzip2 -dk "$file"
                else
                    bzip2 -dk "$file"
                end
            case '*.bz3'
                if command -q bzip3
                    bzip3 -dk "$file"
                else
                    echo "Error: bzip3 not installed" >&2
                    continue
                end
            case '*.zst'
                if command -q zstd
                    zstd -dk "$file"
                else
                    echo "Error: zstd not installed" >&2
                    continue
                end

            case '*.zip'
                unzip -q "$file"
            case '*.7z'
                7z x "$file" >/dev/null
            case '*.rar'
                if command -q unrar
                    unrar x "$file" >/dev/null
                else if command -q 7z
                    7z x "$file" >/dev/null
                else
                    echo "Error: unrar or 7z required for .rar files" >&2
                    continue
                end
            case '*.Z'
                uncompress "$file"

            case '*'
                echo "Error: Unknown format '$filename'" >&2
                continue
        end

        if test $status -eq 0
            echo "✅ Successfully extracted: $filename"
        else
            echo "❌ Failed to extract: $filename" >&2
        end
    end
end
