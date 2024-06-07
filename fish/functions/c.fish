# Function to compress a list of files using various compression formats
function c
    # Check if the number of arguments is greater than 1
    if test (count $argv) -le 1
        echo "Usage: file1 ... fileN t|z|g|zs|x|b|7"
        return 1
    end

    # Extract the list of files and the compression format from arguments
    set -l files $argv[1..-2]
    set -l compression_format $argv[-1]

    # Loop through each file and apply the specified compression
    for file in $files
        switch $compression_format
            case t
                tar cvf {$file}.tar $file
                set -l ext tar
            case z
                zip -r {$file}.zip $file
                set -l ext zip
            case 7
                7z a {$file}.7z $file
                set -l ext 7z
            case g
                if test -d $file
                    tar -I pigz -cvf {$file}.tar.gz $file
                    set -l ext tar.gz
                else
                    pigz -kv $file
                    set -l ext gz
                end
            case b
                if test -d $file
                    tar -I pbzip2 -cvf {$file}.tar.bz2 $file
                    set -l ext tar.bz2
                else
                    pbzip2 -kv $file
                    set -l ext bz2
                end
            case x
                if test -d $file
                    tar -I pixz -cvf $file.tar.xz $file
                    set -l ext tar.xz
                else
                    pixz -k $file
                    set -l ext xz
                end
            case zs
                if test -d $file
                    tar -I 'zstdmt -19' -cvf {$file}.tar.zst $file
                    set -l ext tar.zst
                else
                    zstdmt -19 -kv $file
                    set -l ext zst
                end
            case '*'
                echo "'$file' cannot be compressed, unknown '$compression_format' compression format" 2>&1
                return 1
        end

        # Calculate and display compression details
        set -l compressed_file $file.$ext
        set -l original_size (command du -s "$file" | cut -f1)
        set -l compressed_size (command du "$compressed_file" | cut -f1)
        echo "Compressed file: $compressed_file"
        set -l compression_ratio (awk "BEGIN{printf \"%0.2f\", $original_size/$compressed_size}")
        echo ""
        echo "Compression ratio: $compression_ratio"
        echo "Final size: (command du -h $compressed_file | cut -f1)"
        echo "Initial size: (command du -hs $file | cut -f1)"
    end
end
