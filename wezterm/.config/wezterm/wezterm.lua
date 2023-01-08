local wezterm = require 'wezterm';

return {
 term = "wezterm",
  -- tempfile=$(mktemp) \
  -- && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
  -- && tic -x -o ~/.terminfo $tempfile \
  -- && sudo tic -x -o /usr/share/terminfo $tempfile \
  -- && rm $tempfile
  exit_behavior = "Close",
  enable_wayland = true,
  enable_kitty_keyboard = true,
  use_fancy_tab_bar = false,
  font = wezterm.font_with_fallback {
    "Hack Nerd Font",
    "Broot Icons Visual Studio Code",
  },
  font_size = 18.0,
  color_scheme = "Catppuccin Mocha",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
}
