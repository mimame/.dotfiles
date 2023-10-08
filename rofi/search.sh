#!/usr/bin/env bash

if [ "$1" ]; then
  (vivaldi --incognito https://www.google.com/search?q="$1" &)
  # Corner case: Try to open a url without any Vivaldi instance opened
  # Result: rofi is never closed by itself
  if ! "pgrep --full vivaldi"; then
    pkill rofi
  fi
fi
