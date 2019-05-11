#!/usr/bin/env bash

#PUT THIS FILE IN ~/.local/share/rofi/finder.sh
#USE: rofi  -show find -modi find:~/.local/share/rofi/finder.sh
if [ ! -z "$@" ]
then
  QUERY=$@
  if [[ "$@" == /* ]]
  then
    coproc ( mimeopen "$@"  > /dev/null 2>&1 )
    exec 1>&-
    exit;
  else
    fd --hidden --no-ignore --exclude .git --fixed-strings --type file --type directory  "$QUERY" /home /tmp /usr
  fi
fi
