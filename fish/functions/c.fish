# Function to compress a list of files using various compression formats
function c
    # Check if the number of arguments is greater than 1
    if test (count $argv) -le 1
        echo "Usage: c file1 [file2 ...] compression_format"
        echo "Compression formats:"
        echo "  t  - tar archive"
        echo "  z  - zip archive"
        echo "  g  - gzip compression (tar.gz for directories)"
        echo "  zs - zstd compression (tar.zst for directories)"
        echo "  x  - xz compression (tar.xz for directories)"
        echo "  7  - 7zip archive"
        echo "  b  - bzip3 compression (tar.bz3 for directories)"
        echo "  b2  - bzip2 compression (tar.bz2 for directories)"
        return 1
    end

    # Extract the list of files and the compression format from arguments
    set -l files $argv[1..-2]
    set -l compression_format $argv[-1]
    set -l ext ''
    set -l is_dir (test -d $file && echo true || echo false)
    # Loop through each file/folder and apply the specified compression
    for file in $files
        switch $compression_format
            case t
                set ext tar
                tar cvf {$file}.$ext $file
            case z
                set ext zip
                zip -r {$file}.$ext $file
            case 7
                set ext 7z
                7z a {$file}.$ext $file
            case g
                if $is_dir
                    set ext tar.gz
                    tar -I pigz -cvf {$file}.$ext $file
                else
                    set ext gz
                    pigz -kv $file
                end
            case b2
                if $is_dir
                    set -l ext tar.bz2
                    tar -I pbzip2 -cvf {$file}.$ext $file
                else
                    set ext bz2
                    pbzip2 -kv $file
                end
            case b
                if $is_dir
                    set ext tar.bz3
                    tar -cv $file | bzip3 -j 4 -kv >{$file}.$ext
                else
                    set ext bz3
                    bzip3 -j 4 -kv $file
                end
            case x
                if $is_dir
                    set ext tar.xz
                    tar -I pixz -cvf $file.$ext $file
                else
                    set ext xz
                    pixz -kv $file
                end
            case zs
                if $is_dir
                    set ext tar.zst
                    tar -I 'zstdmt -19' -cvf {$file}.$ext $file
                else
                    set ext zst
                    zstdmt -19 -kv $file
                end
            case '*'
                echo "Error: Cannot compress '$file' - '$compression_format' is not a valid compression format" >&2
                echo "Valid formats are: t(tar), z(zip), g(gzip), zs(zstd), x(xz), 7(7zip), b(bzip3), b2(bzip2)" >&2
                return 1
        end

        # Calculate and display compression details
        set -l compressed_file "$file.$ext"
        set -l original_size (du -sb "$file" | cut -f1)
        set -l compressed_size (du -b "$compressed_file" | cut -f1)
        echo ""
        echo "Compressed file: $compressed_file"
        set -l compression_ratio (printf "%.2f" (math "$original_size / $compressed_size"))
        echo "Compression ratio: $compression_ratio"
        echo "Initial size: $(command du -sh $file | cut -f1)"
        echo "Final size: $(command du -h $compressed_file | cut -f1)"
    end
end
