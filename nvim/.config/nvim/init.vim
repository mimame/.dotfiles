" vim: foldmethod=marker foldlevel=0 foldenable

" Load .vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

" Gutter symbols update immediately (very weird glitches in vim)
" https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
set updatetime=100

" Add --servername support {{{
" https://github.com/lervag/vimtex/wiki/introduction#neovim
let g:vimtex_compiler_progname = 'nvr'
" }}}

" Load .init.vim when writing {{{
augroup myvimrc
  au!
  au BufWritePost init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}
"
