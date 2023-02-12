function ssh --description "SSH for wezterm or Kitty terminals"
    if test "$TERM" = 'wezterm'
        wezterm ssh "$argv"
    else if test "$TERM" = 'xterm-kitty'
        kitty +kitten ssh "$argv"
    else
        ssh "$argv"
    end
end
