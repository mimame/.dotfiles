-- ----------------------------------------------------------------------------
-- Yazi Plugin Configuration
--
-- WHY: Extends Yazi with powerful plugins for better UX.
-- ----------------------------------------------------------------------------

-- WHY relative-motions: Vim-like jump-to-line with number keys (1-9)
require("relative-motions"):setup({
  show_numbers = "relative", -- Show relative line numbers
  show_motion = true, -- Visual feedback during motion
  enter_mode = "first", -- Start at first file after jump
})

-- WHY starship: Beautiful, informative shell prompt in file manager footer
require("starship"):setup()

-- WHY git: Show git status indicators (modified, added, deleted)
require("git"):setup()

-- WHY full-border: Rounded borders for better visual separation
require("full-border"):setup({
  type = ui.Border.ROUNDED,
})

-- WHY smart-enter: Open files/directories with context-aware behavior
require("smart-enter"):setup({
  open_multi = true, -- Open multiple selected files at once
})

-- WHY mime-ext: Extension-DB MIME detection replaces file(1) spawns (faster fetch
-- pipeline; open/preview rules in yazi.toml key off MIME). fallback_file1 sends
-- unknown extensions back to the builtin file(1) fetcher for accuracy.
-- smart-filter/smart-paste/toggle-pane/zoom/chmod/visual-pivot are keymap-only.
require("mime-ext.local"):setup({
  fallback_file1 = true,
})
