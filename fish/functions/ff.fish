function ff --description "Open private Firefox window with search or URL"
    set -l browser firefox
    set -l url "https://duckduckgo.com/"

    # Handle arguments
    if set -q argv[1]
        # If the first argument looks like a URL, use it directly
        if string match -qr '^https?://|^\w+\.\w+' -- "$argv[1]"
            set url "$argv[1]"
        else
            # Otherwise, treat arguments as a search query
            set -l query (string join "+" -- $argv)
            set url "https://duckduckgo.com/?q=$query"
        end
    end

    # Cross-platform execution
    if test (uname) = Darwin
        if command -q firefox
            firefox --private-window "$url" &>/dev/null & disown
        else
            # Fallback to 'open' on macOS if 'firefox' bin is not in PATH
            open -a Firefox --args --private-window "$url"
        end
    else
        if not command -q firefox
            echo "Error: Firefox not found in PATH" >&2
            return 1
        end
        firefox --private-window "$url" &>/dev/null & disown
    end
end
