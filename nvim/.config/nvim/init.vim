" vim: foldmethod=marker foldlevel=0 foldenable

" Load .vimrc {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
" }}}

" Gutter symbols update immediately (very weird glitches in vim)
" https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
set updatetime=100

" ALE config for NeoVim {{{
" Add support for virtualtext
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '  '
" }}}

" Add --servername support {{{
" https://github.com/lervag/vimtex/wiki/introduction#neovim
let g:vimtex_compiler_progname = 'nvr'
" }}}

" NeoVim only supports interactive commands with :terminl instead :! like vim
" https://github.com/neovim/neovim/wiki/FAQ#-and-system-do-weird-things-with-interactive-processes
nmap <leader>ti :terminal <cr>tig && exit<cr>

" To enter |Terminal-mode| automatically
autocmd TermOpen * startinsert

" Load .init.vim when writing {{{
augroup myvimrc
  au!
  au BufWritePost init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}

