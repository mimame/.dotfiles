function c --description "Compress files/directories using various formats"
    if test (count $argv) -le 1
        echo "Usage: c <target...> <format_code_or_extension>"
        echo "Example: c my_file g          (compresses to my_file.gz)"
        echo "Example: c my_dir  zs         (archives to my_dir.tar.zst)"
        echo "Example: c my_dir  tar.zst    (archives to my_dir.tar.zst)"
        echo ""
        echo "Format Codes / Extensions:"
        echo "  t  (tar), z (zip), 7 (7z), g (gzip), b2 (bzip2), b (bzip3), x (xz), zs (zstd)"
        return 1
    end

    set -l targets $argv[1..-2]
    # Strip leading dot if user provided one (e.g., .tar.gz -> tar.gz)
    set -l format (string trim -l -c . $argv[-1])

    for target in $targets
        if not test -e "$target"
            echo "Error: '$target' not found"
            continue
        end

        # Strip trailing slash for cleaner filenames
        set -l target (string trim -r -c / $target)
        set -l is_dir false
        test -d "$target"; and set is_dir true
        set -l ext ""

        # Calculate original size (in bytes)
        set -l original_size (math (du -sk "$target" | cut -f1) \* 1024)

        switch $format
            case t tar
                set ext tar
                tar -cf "$target.tar" "$target"
            case z zip
                set ext zip
                zip -r "$target.zip" "$target"
            case 7 7z
                set ext 7z
                7z a "$target.7z" "$target"
            case g gz gzip tar.gz
                if $is_dir
                    set ext tar.gz
                    if command -q pigz
                        tar -cf - "$target" | pigz >"$target.$ext"
                    else
                        tar -czf "$target.$ext" "$target"
                    end
                else
                    set ext gz
                    if command -q pigz
                        pigz -k "$target"
                    else
                        gzip -k "$target"
                    end
                end
            case b2 bz2 bzip2 tar.bz2
                if $is_dir
                    set ext tar.bz2
                    if command -q pbzip2
                        tar -cf - "$target" | pbzip2 >"$target.$ext"
                    else
                        tar -cjf "$target.$ext" "$target"
                    end
                else
                    set ext bz2
                    if command -q pbzip2
                        pbzip2 -k "$target"
                    else
                        bzip2 -k "$target"
                    end
                end
            case b bz3 bzip3 tar.bz3
                if command -q bzip3
                    if $is_dir
                        set ext tar.bz3
                        tar -cf - "$target" | bzip3 -j 4 >"$target.$ext"
                    else
                        set ext bz3
                        bzip3 -j 4 -k "$target"
                    end
                else
                    echo "Error: 'bzip3' not found."
                    continue
                end
            case x xz tar.xz
                if $is_dir
                    set ext tar.xz
                    if command -q pixz
                        tar -cf - "$target" | pixz >"$target.$ext"
                    else
                        tar -cJf "$target.$ext" "$target"
                    end
                else
                    set ext xz
                    if command -q pixz
                        pixz -k "$target"
                    else
                        xz -k "$target"
                    end
                end
            case zs zst zstd tar.zst
                if $is_dir
                    set ext tar.zst
                    if command -q zstdmt
                        tar -cf - "$target" | zstdmt -9 >"$target.$ext"
                    else if command -q zstd
                        tar -cf - "$target" | zstd -T0 -9 >"$target.$ext"
                    else
                        echo "Error: 'zstd' not found."
                        continue
                    end
                else
                    set ext zst
                    if command -q zstdmt
                        zstdmt -9 -k "$target"
                    else if command -q zstd
                        zstd -T0 -9 -k "$target"
                    else
                        echo "Error: 'zstd' not found."
                        continue
                    end
                end
            case '*'
                echo "Error: Unknown format '$format'"
                echo "Valid codes: t, z, 7, g, b2, b, x, zs (or full extensions like tar.gz)"
                return 1
        end

        set -l compressed_file "$target.$ext"
        if test -f "$compressed_file"
            set -l compressed_size (math (du -sk "$compressed_file" | cut -f1) \* 1024)
            set -l ratio (printf "%.2f" (math "$original_size / $compressed_size"))

            echo ""
            echo "Compressed: $compressed_file"
            echo "Ratio:      $ratio"
            echo "Original:   $(du -sh "$target" | cut -f1)"
            echo "Final:      $(du -sh "$compressed_file" | cut -f1)"
        else
            echo "Error: Compression failed for '$target'"
        end
    end
end
