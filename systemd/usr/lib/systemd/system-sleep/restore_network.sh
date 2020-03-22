#!/usr/bin/sh

case $1/$2 in
post/*)
  rmmod r8168
  modprobe r8168
  ;;
esac
