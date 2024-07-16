require "nvchad.options"

-- add yours here!
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.spell = true
vim.opt.wrap = true
-- Concealed text is hidden unless a custom replacement character defined
vim.wo.conceallevel = 2
-- set cursor of insert mode as vertical line
vim.opt.guicursor = "i:ver1"
-- Set sh as default shell
-- https://www.lunarvim.org/docs/troubleshooting#are-you-using-fish
vim.opt.shell = "/bin/sh"
-- Don't use swap files
vim.opt.swapfile = false
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
