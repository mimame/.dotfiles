-- Pull in the wezterm API
local wezterm = require 'wezterm';
local act = wezterm.action
-- This table will hold the configuration.
local config = {}

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

-- https://github.com/wez/wezterm/issues/2588#issuecomment-1268054635
function make_mouse_binding(dir, streak, button, mods, action)
  return {
    event = { [dir] = { streak = streak, button = button } },
    mods = mods,
    action = action,
  }
end

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.term = 'wezterm'
-- tempfile=$(mktemp) \
-- && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
-- && tic -x -o ~/.terminfo $tempfile \
-- && sudo tic -x -o /usr/share/terminfo $tempfile \
-- && rm $tempfile
config.exit_behavior = 'Close'
config.enable_wayland = true
config.enable_kitty_keyboard = true
config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.hide_mouse_cursor_when_typing = false
config.window_close_confirmation = 'NeverPrompt'
config.warn_about_missing_glyphs = false
config.font = wezterm.font_with_fallback {
    "Hack Nerd Font",
    "Broot Icons Visual Studio Code",
}
config.check_for_updates = false
config.font_size = 18.0
config.color_scheme = 'Catppuccin Mocha'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Add copy on select
config.mouse_bindings = {
  make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
  make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
  make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
  make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
  make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
  make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
}


-- and finally, return the configuration to wezterm
return config
