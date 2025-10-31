#!/usr/bin/env fish
#
# Rofi Private Web Search
#
# A Rofi script mode to quickly perform a private web search using DuckDuckGo.
# It opens the search query in a new private Firefox window.

# Rofi passes the typed text as an argument.
if count $argv >0
    # Construct the DuckDuckGo search URL and launch in a private Firefox window.
    # The process is backgrounded to allow Rofi to close immediately.
    firefox -private-window "https://duckduckgo.com/?q=$argv[1]" &

    # Corner case: If no Firefox instance is running when this script is called,
    # the new `firefox &` process might detach in a way that doesn't signal
    # completion to Rofi, leaving the Rofi window open.
    # This check detects that scenario and manually kills the Rofi process
    # to ensure the launcher closes as expected.
    if not pgrep --full firefox
        pkill rofi
    end
end
