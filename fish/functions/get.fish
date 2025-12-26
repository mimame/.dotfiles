function get --description "Download file using the best available tool (aria2c, wget2, wcurl, wget, curl)" --argument url path
    if test -z "$url"
        echo "Usage: get <url> [path]"
        echo "  path: Local file path. If omitted, downloads to current directory with remote name."
        echo "        Use '-' for stdout."
        return 1
    end

    # Handle stdout streaming explicitly.
    if test "$path" = -
        if command -q wget2
            wget2 --quiet --output-document=- $url
        else if command -q wget
            wget --quiet --output-document=- $url
        else if command -q wcurl
            wcurl --curl-options="--silent --show-error" --output=- $url
        else if command -q curl
            curl --fail --silent --show-error --location $url
        else
            echo "🔴 Error: No tool found for streaming (wget2, wget, wcurl, curl)." >&2
            return 1
        end
        return 0
    end

    # Handle file download
    if test -n "$path"
        mkdir -p (dirname $path)
    end

    # Select tool
    # Priority:
    # 1. Accelerators (aria2c) - Fastest for large files
    # 2. Modern Standards (wget2, wcurl) - Good defaults, HTTP/2
    # 3. Legacy/Basic (wget, curl) - Fallbacks

    if command -q aria2c
        # aria2c is fast but needs distinct dir and filename for output
        echo "🚀 Using aria2c..." >&2
        set -l params --max-connection-per-server=4 --split=4 --min-split-size=1M --continue=true --max-concurrent-downloads=5 --file-allocation=none
        if test -n "$path"
            aria2c --dir=(dirname $path) --out=(basename $path) $params $url
        else
            aria2c $params $url
        end
    else if command -q wget2
        echo "📥 Using wget2..." >&2
        set -l params --continue --progress=bar --timestamping --retry-on-http-error=503
        if test -n "$path"
            wget2 --output-document=$path $params $url
        else
            wget2 $params $url
        end
    else if command -q wcurl
        echo "📥 Using wcurl..." >&2
        set -l params --curl-options="--clobber --continue-at -"
        if test -n "$path"
            wcurl --output=$path $params $url
        else
            wcurl $params $url
        end
    else if command -q wget
        echo "📥 Using wget..." >&2
        # Warn about suboptimal tool
        set_color yellow
        echo "💡 Tip: Install aria2c or wget2 for faster downloads."
        set_color normal
        set -l params --continue --progress=bar --timestamping
        if test -n "$path"
            wget --output-document=$path $params $url
        else
            wget $params $url
        end
    else if command -q curl
        echo "📥 Using curl..." >&2
        # Warn about suboptimal tool
        set_color yellow
        echo "💡 Tip: Install aria2c or wget2 for faster downloads."
        set_color normal
        set -l params --continue-at - --location --progress-bar --remote-time --retry 3 --retry-delay 5
        if test -n "$path"
            curl --output $path $params $url
        else
            curl --remote-name $params $url
        end
    else
        echo "🔴 Error: No suitable download tool found (aria2c, wget2, wcurl, wget, curl)." >&2
        return 1
    end
end
