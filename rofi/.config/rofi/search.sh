#!/usr/bin/env bash

if [ "$1" ]; then
  (firefox-developer-edition --private-window https://www.google.com/search?q="$1" &)
  # Corner case: Try to open a url without any Firefox instance opened
  # Result: rofi is never closed by itself
  if ! "pgrep --full firefox"; then
    pkill rofi
  fi
fi
