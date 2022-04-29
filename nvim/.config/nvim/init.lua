-- nvim api aliases
cmd = vim.cmd -- to execute Vim commands alias to nvim_exec() e.g. cmd('pwd')
fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
g = vim.g -- a table to access global variables
opt = vim.opt -- to set options
api = vim.api -- to call nvim_create_autocmd api.nvim_create_augroup

-- Install packer automatically
local packer_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
  cmd('packadd packer.nvim')
end

require('defaults')
require('plugins')
require('mappings')
require('theme')
