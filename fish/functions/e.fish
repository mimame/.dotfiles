# # Extract any kind of compressed files list
function e
    for file in "$argv"
        # switch (string split --max 1 --field 2 "." "$file")
        switch "$file"
            case "*.tar"
                tar xvf "$file"
            case "*.tar.gz" or "*.tgz"
                tar -I pigz -xvf "$file"
            case "*.tar.xz" or "*.txz"
                tar -I pixz -xvf "$file"
            case "*.tar.bz2" or "*.tbz2"
                tar -I pbzip2 -xvf "$file"
            case "*.tar.zst" or "*.tzst"
                tar -I zstdmt -xvf "$file"
            case "*.bz2"
                pbzip2 -dkv "$file"
            case "*.xz"
                pixz -dk "$file"
            case "*.gz"
                pigz -dkv "$file"
            case "*.zst"
                zstdmt -dkv "$file"
            case "*.zip"
                unzip "$file"
            case "*.7z"
                7z x "$file"
            case "*.Z"
                uncompress "$file"
            case "*.rar"
                unrar e "$file"
            case '*'
                echo "'$file' cannot be extracted, unknown compression format" 2>&1
        end
    end
end
