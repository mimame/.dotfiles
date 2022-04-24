# # compress any kind of files list
function c
    set files $argv[1..-2]
    set compression_format $argv[-1]
    echo "FILES: $files"
    echo "compression_format: $compression_format"
    for file in $files
        switch $compression_format
            case t
                tar cvf {$file}.tar $file
                set ext tar
            case z
                zip -r {$file}.zip $file
                set ext zip
            case 7
                7z a {$file}.7z $file
                set ext 7z
            case g
                if test -d $file
                    tar -I pigz -cvf {$file}.tar.gz $file
                    set ext tar.gz
                else
                    pigz -kv $file
                    set ext gz
                end
            case b
                if test -d $file
                    tar -I pbzip2 -cvf {$file}.tar.bz2 $file
                    set ext tar.bz2
                else
                    pbzip2 -kv $file
                    set ext bz2
                end
            case x
                if test -d $file
                    tar -I pixz -cvf $file.tar.xz $file
                    set ext tar.xz
                else
                    pixz -k $file
                    set ext xz
                end
            case zs
                if test -d $file
                    tar -I 'zstdmt -19' -cvf {$file}.tar.zst $file
                    set ext tar.zst
                else
                    zstdmt -19 -kv $file
                    set ext zst
                end
            case '*'
                echo "'$file' cannot be compressed, unknown '$argv[2]' compression format" 2>&1
                return 1
        end
        set compressed_file $file*.$ext
        set compressed_size (command du "$compressed_file" | cut -f1)
        set original_size (command du -s "$argv[1]" | cut -f1)
        echo "Compressed file: $compressed_file"
        set compression_ration (awk "BEGIN{printf \"%0.2f\", $original_size/$compressed_size}")
        echo ""
        echo "Compression ration: $compression_ration"
        echo "Final size: $(command du -h $compressed_file | cut -f1)"
        echo "Initial size: $(command du -hs $file | cut  -f1)"
    end
end
