local wezterm = require 'wezterm';

-- https://github.com/wez/wezterm/issues/2588#issuecomment-1268054635
function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

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
  enable_tab_bar = false,
  window_close_confirmation = 'NeverPrompt',
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
  },

  -- Add copy on select
  mouse_bindings = {
    make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
    make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
  },
}
