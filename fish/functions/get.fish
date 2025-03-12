function get --description "Download files with the best available download tool"
    # Check for available download tools in order of preference
    if command -v aria2c >/dev/null 2>&1
        echo "Using aria2c for download..."
        aria2c --max-connection-per-server=2 --split=2 --min-split-size=1M --continue=true --max-concurrent-downloads=5 --file-allocation=none "$argv"
    else if command -v axel >/dev/null 2>&1
        echo "Using axel for download..."
        axel --num-connections=2 --alternate --verbose "$argv"
    else if command -v wget2 >/dev/null 2>&1
        echo "Using wget2 for download..."
        wget2 --continue --progress=bar --timestamping --retry-on-http-error=503 "$argv"
    else if command -v curl >/dev/null 2>&1
        echo "Using curl for download..."
        curl --continue-at - --location --progress-bar --remote-name --remote-time --retry 3 --retry-delay 5 "$argv"
    else
        echo "No suitable download tool found. Please install aria2c, axel, wget2, or curl." >&2
        return 1
    end
end
