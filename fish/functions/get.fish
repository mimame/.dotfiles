function get --description "Download file using the best available tool" --argument url target
    # Description:
    #   Downloads a file from a URL using the best tool available on the system.
    #   Prioritizes: aria2c > wget2 > wcurl > wget > curl.
    #
    # Arguments:
    #   url: The source URL to download.
    #   target: Optional. Local path (file or directory) or '-' for stdout.
    #
    # Usage:
    #   get <url> [target_path]

    if test -z "$url"
        echo "Usage: get <url> [target_path]"
        echo "  target_path: Local file or directory. If omitted, downloads to CWD."
        echo "               Use '-' for stdout."
        return 1
    end

    # 1. Determine the best tool available
    set -l tools aria2c wget2 wcurl wget curl
    set -l tool
    for t in $tools
        if command -q $t
            set tool $t
            break
        end
    end

    if test -z "$tool"
        echo "Error: No download tool found (tried: $tools)" >&2
        return 1
    end

    # 2. Handle stdout streaming
    if test "$target" = -
        switch $tool
            case aria2c
                # aria2c isn't optimized for stdout; fallback to others if available
                if command -q wget2
                    wget2 -q -O- "$url"
                else if command -q wget
                    wget -q -O- "$url"
                else
                    curl -fsSL "$url"
                end
            case wget2 wget
                $tool -q -O- "$url"
            case wcurl
                wcurl --curl-options="-fsSL" --output=- "$url"
            case curl
                curl -fsSL "$url"
        end
        return
    end

    # 3. Process target path and directory
    set -l out_dir "."
    set -l out_file ""

    if test -n "$target"
        if test -d "$target"
            set out_dir "$target"
        else
            set out_dir (path dirname "$target")
            set out_file (path basename "$target")
            mkdir -p "$out_dir"
        end
    end

    # 4. Execute download with tool-specific optimizations
    echo "📥 Downloading via $tool..." >&2

    switch $tool
        case aria2c
            # Optimize for speed: 8 connections, 1M split size
            set -l params --max-connection-per-server=8 --split=8 --min-split-size=1M \
                --continue=true --file-allocation=none --dir="$out_dir"
            if test -n "$out_file"
                set -a params --out="$out_file"
            end
            aria2c $params "$url"

        case wget2
            # Robust downloading with retries and progress bar
            set -l params --progress=bar --retry-on-http-error=503
            if test -n "$out_file"
                # Note: --timestamping does nothing with -O, so we use --continue instead.
                # This avoids the "timestamping does nothing in combination with -O" warning.
                wget2 --output-document="$out_dir/$out_file" --continue $params "$url"
            else
                # For directory-based downloads, --timestamping is safer as it avoids 416 errors
                # if the file is already fully retrieved.
                wget2 --directory-prefix="$out_dir" --timestamping $params "$url"
            end

        case wcurl
            if test -n "$out_file"
                wcurl --output="$out_dir/$out_file" "$url"
            else
                wcurl --directory-prefix="$out_dir" "$url"
            end

        case wget
            set_color yellow
            echo "💡 Tip: Install aria2c or wget2 for faster downloads."
            set_color normal
            set -l params --progress=bar
            if test -n "$out_file"
                # Remove --timestamping to avoid warning with -O
                wget --output-document="$out_dir/$out_file" --continue $params "$url"
            else
                wget --directory-prefix="$out_dir" --timestamping --continue $params "$url"
            end

        case curl
            set_color yellow
            echo "💡 Tip: Install aria2c or wget2 for faster downloads."
            set_color normal
            # Standard resilient curl flags
            set -l params --continue-at - --location --progress-bar --remote-time --retry 3
            if test -n "$out_file"
                curl --output "$out_dir/$out_file" $params "$url"
            else
                # Use output-dir for modern curl, falls back to CWD behavior
                curl --remote-name --output-dir "$out_dir" $params "$url"
            end
    end
end
