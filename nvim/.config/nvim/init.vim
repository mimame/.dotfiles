" vim: foldmethod=marker foldlevel=0 foldenable

" Load .vimrc {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
" }}}

" Gutter symbols update immediately (very weird glitches in vim)
" https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
set updatetime=100

" Add --servername support {{{
" https://github.com/lervag/vimtex/wiki/introduction#neovim
let g:vimtex_compiler_progname = 'nvr'
" }}}

" NeoVim only supports interactive commands with :terminl instead :! like vim
" https://github.com/neovim/neovim/wiki/FAQ#-and-system-do-weird-things-with-interactive-processes
nmap <leader>ti :terminal <cr>tig && exit<cr>

" To enter |Terminal-mode| automatically
autocmd TermOpen * startinsert

" close a terminal buffer automatically if the command is successful {{{
" https://www.reddit.com/r/neovim/comments/7xonzm/how_to_close_a_terminal_buffer_automatically_if/dud0vxn
function! OnTermClose()
    " Try to move the cursor to the last line containing text
    try
        $;?.
    catch
        " The buffer is empty here. This shouldn't ever happen
        return
    endtry
    " Is the last line an error message?
    if match(getline('.'), 'make: \*\*\* \[[^\]]\+] Error ') == -1
        call feedkeys('a ')
    endif
endfunction

augroup MY_TERM_AUGROUP
    autocmd!
    au TermClose * silent call OnTermClose()
augroup END
" }}}

" Load .init.vim when writing {{{
augroup myvimrc
  au!
  au BufWritePost init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}

