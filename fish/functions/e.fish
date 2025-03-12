function e --description "Extract various archive and compressed files based on their extensions"
    if test (count $argv) -eq 0
        echo "Usage: e [file1 file2 ...]"
        echo "Extracts archives and compressed files based on their extensions."
        echo "Supported formats:"
        echo "  • Archives: tar, zip, 7z, rar"
        echo "  • Compressed: gz, xz, bz2, bz3, zst"
        echo "  • Combined: tar.gz, tar.xz, tar.bz2, tar.zst"
        return 1
    end

    for file in $argv
        set -l filename (basename $file)

        # Check if file exists
        if not test -f "$file"
            echo "🚫 Error: '$file' does not exist or is not a regular file" >&2
            continue
        end

        echo "📦 Extracting: $filename"

        switch $filename
            # TAR + Compression variants
            case '*.tar.gz' '*.tgz'
                echo "  Using: tar with pigz (gzip) decompression"
                tar -I pigz -xvf $file
            case '*.tar.xz' '*.txz'
                echo "  Using: tar with pixz (xz) decompression"
                tar -I pixz -xvf $file
            case '*.tar.bz2' '*.tbz2'
                echo "  Using: tar with pbzip2 decompression"
                tar -I pbzip2 -xvf $file
            case '*.tar.bz3' '*.tbz3'
                echo "  Using: tar with pbzip3 decompression"
                tar -I bzip3 -xvf $file
            case '*.tar.zst' '*.tzst'
                echo "  Using: tar with zstd decompression"
                tar -I zstdmt -xvf $file
            case '*.tar'
                echo "  Using: tar extraction"
                tar xvf $file

                # Single file compression
            case '*.gz'
                echo "  Using: pigz decompression"
                pigz -dkv $file
            case '*.xz'
                echo "  Using: pixz decompression"
                pixz -dk $file
            case '*.bz2'
                echo "  Using: pbzip2 decompression"
                pbzip2 -dkv $file
            case '*.bz3'
                echo "  Using: pbzip2 decompression"
                bzip3 -dkv $file
            case '*.zst'
                echo "  Using: zstd decompression"
                zstdmt -dkv $file

                # Archive formats
            case '*.zip'
                echo "  Using: unzip"
                unzip $file
            case '*.7z'
                echo "  Using: 7z extraction"
                7z x $file
            case '*.Z'
                echo "  Using: uncompress"
                uncompress $file
            case '*.rar'
                echo "  Using: unrar extraction"
                unrar x $file

                # Unknown format
            case '*'
                echo "❌ Error: '$filename' cannot be extracted, unknown compression format" >&2
                continue
        end

        if test $status -eq 0
            echo "✅ Successfully extracted: $filename"
        else
            echo "❌ Failed to extract: $filename" >&2
        end
    end
end
