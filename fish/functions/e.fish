# Extract any kind of compressed files
function e
    for file in "$argv"
        switch (string split --max 1 --field 2 "." "$file")
            case tar
                tar xvf "$file"
            case tgz "*tar.gz"
                tar -I pigz -xvf "$file"
            case txz "*tar.xz"
                tar -I pixz -xvf "$file"
            case tbz2 "*tar.bz2"
                tar -I pbzip2 -xvf "$file"
            case tzst "*tar.zst"
                tar -I zstdmt -xvf "$file"
            case bz2
                pbzip2 -dkv "$file"
            case xz
                pixz -dk "$file"
            case gz
                pigz -dkv "$file"
            case zst
                zstdmt -dkv "$file"
            case zip
                unzip "$file"
            case 7z
                7z x "$file"
            case Z
                uncompress "$file"
            case rar
                unrar e "$file"
            case '*'
                echo "'$file' cannot be extracted, unknown compression format" >&2
        end
    end
end
