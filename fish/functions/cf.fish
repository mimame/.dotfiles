# Function to compress a list of files using ouch cli compressor
# This version attempts to mimic the original format selection using single characters.
function cf
    if test (count $argv) -le 1
        echo "Usage: c file1 [file2 ...] compression_format"
        echo "Compression formats:"
        echo "  z  - zip archive (e.g., file.zip or files.zip)"
        echo "  g  - gzip compression (e.g., file.gz or files.tar.gz)"
        echo "  zs - zstd compression (e.g., file.zst or files.tar.zst)"
        echo "  x  - xz compression (e.g., file.xz or files.tar.xz)"
        echo "  7  - 7zip archive (e.g., file.7z or files.7z)"
        # Note: 't' (tar only) and 'b' (bzip3/bzip2) are trickier with ouch directly this way
        return 1
    end

    set -l files $argv[1..-2]
    set -l compression_format $argv[-1]
    set -l output_ext ""

    switch $compression_format
        case z
            set output_ext zip
        case g
            set output_ext "tar.gz" # For general use with multiple files/dirs
        case zs
            set output_ext "tar.zst"
        case x
            set output_ext "tar.xz"
        case 7
            set output_ext 7z
        case '*'
            echo "Error: Invalid compression format '$compression_format'." >&2
            echo "Supported formats: z(zip), g(gzip), zs(zstd), x(xz), 7(7zip)." >&2
            return 1
    end

    # Determine a base name for the output archive
    set -l base_name ""
    if test (count $files) -eq 1
        # If only one file, use its name as base
        set base_name (basename $files[1] | string replace -r '\.[^.]+$' '')
    else
        # If multiple files, use a generic name or first file's name
        set base_name archive
        # Could prompt user for name or use first file's name, but keeping it simple for now
    end

    set -l output_archive "$base_name.$output_ext"

    echo "Compressing '$files' into '$output_archive' using ouch..."
    ouch compress $files $output_archive

    if test $status -eq 0
        echo ""
        echo "Compression complete!"
        if test -f "$output_archive"
            set -l total_original_size 0
            for f in $files
                if test -e "$f"
                    set total_original_size (math "$total_original_size + (du -sb "$f" | cut -f1)")
                end
            end

            set -l compressed_size (du -b "$output_archive" | cut -f1)
            set -l compression_ratio (printf "%.2f" (math "$total_original_size / $compressed_size"))

            echo "Compressed archive: $output_archive"
            echo "Compression ratio: $compression_ratio"
            echo "Initial total size: $(numfmt --to=iec-i --suffix=B $total_original_size)"
            echo "Final size: $(command du -h $output_archive | cut -f1)"
        else
            echo "Error: Output archive '$output_archive' was not created." >&2
            return 1
        end
    else
        echo "Error: Compression failed with ouch." >&2
        return 1
    end
end
