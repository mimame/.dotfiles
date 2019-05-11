#!/usr/bin/env bash

if [ "$1" ]
then
  (firefox-developer-edition --private-window https://www.google.com/search?q="$1" &)
fi
