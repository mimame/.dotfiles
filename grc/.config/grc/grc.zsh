if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then

  # Supported commands
  cmds=(
    cc
    docker
    docker-compose
    docker-machine
    gcc
    gmake
    ifconfig
    iostat
    journalctl
    kubectl
    make
    ping6
    sar
    semanage
    traceroute6
  )

  # Set alias for available commands.
  for cmd in $cmds $(\ls ~/.config/grc | sed 's/conf\.//;/grc/d') ; do
    if (( $+commands[$cmd] )) ; then
      alias $cmd="grc $(whence $cmd)"
    fi
  done

  # Clean up variables
  unset cmds cmd
fi
