#!/usr/bin/env bash

#PUT THIS FILE IN ~/.local/share/rofi/finder.sh
#USE: rofi  -show find -modi find:~/.local/share/rofi/finder.sh
if [ ! -z "$@" ]; then
  QUERY=$@
  if [[ "$@" == /* ]]; then
    coproc (TERMINAL='alacritty -e' mimeopen --no-ask "$@" >/dev/null 2>&1)
    exec 1>&-
    exit
  else
    fd --hidden --no-ignore --exclude .git --exclude node_modules "$QUERY" /home /tmp /usr
  fi
fi
