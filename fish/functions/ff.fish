function ff --description "Open private Firefox window with DuckDuckGo search"
    # Launch Firefox in background and detach from shell
    if test -n "$argv"
        firefox --private-window "https://duckduckgo.com/?q=$argv" &>/dev/null & disown
    else
        # If no query, just open DuckDuckGo
        firefox --private-window "https://duckduckgo.com/" &>/dev/null & disown
    end
end
