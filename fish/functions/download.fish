function download --description "Download file or stream to stdout using available tools (wget2, wcurl, wget, curl)" --argument url path
    if test -z "$url"
        echo "Usage: download <url> [path]"
        return 1
    end

    if test -n "$path"
        # Download to file
        mkdir -p (dirname $path)
        if command -q wget2
            wget2 --quiet --continue --output-document=$path $url
        else if command -q wcurl
            wcurl --curl-options="--clobber --continue-at -" --output=$path $url
        else if command -q wget
            wget --quiet --continue --output-document=$path $url
        else if command -q curl
            curl --fail --silent --show-error --location --continue-at - --output $path $url
        else
            echo "🔴 Error: No download tool found (wget2, wcurl, wget, curl)."
            return 1
        end
    else
        # Stream to stdout
        if command -q wget2
            wget2 --quiet --output-document=- $url
        else if command -q wget
            wget --quiet --output-document=- $url
        else if command -q curl
            curl --fail --silent --show-error --location $url
        else
            echo "🔴 Error: No download tool found (wget2, wget, curl)."
            return 1
        end
    end
end
