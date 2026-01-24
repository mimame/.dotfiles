-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false

-- Add characters to isfname to ensure gx picks up full URLs with query parameters
vim.opt.isfname:append("?,=,&")
