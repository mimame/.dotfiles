" vim: foldmethod=marker

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

" Shows the effects of a command incrementally like :substitute
set inccommand=nosplit

" Add --servername support {{{
" https://github.com/lervag/vimtex/wiki/introduction#neovim
let g:vimtex_compiler_progname = 'nvr'
" }}}

" NeoVim only supports interactive commands with :terminl instead :! like vim
" https://github.com/neovim/neovim/wiki/FAQ#-and-system-do-weird-things-with-interactive-processes
nmap <leader>ti :terminal <cr>tig && exit<cr>

" To enter |Terminal-mode| automatically
autocmd TermOpen * startinsert
autocmd BufEnter term://* startinsert

" Use vim tmux navigation flow
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

let g:firenvim_config = {
  \ 'localSettings': {
    \ '.*': {
      \ 'selector': '',
      \ 'priority': 0,
    \ },
    \ 'github\.com': {
        \ 'selector': 'textarea',
        \ 'priority': 1,
    \ },
    \ 'calendar\.google\.com*': {
        \ 'selector': 'div[role="textbox"]',
        \ 'priority': 1,
    \ },
    \ 'mail\.google\.com*': {
        \ 'selector': 'div[role="textbox"]',
        \ 'priority': 1,
    \ },
  \ }
\ }
au BufEnter github.com_*.txt set filetype=markdown
function! s:IsFirenvimActive(event) abort
  if !exists('*nvim_get_chan_info')
    return 0
  endif
  let l:ui = nvim_get_chan_info(a:event.chan)
  return has_key(l:ui, 'client') && has_key(l:ui.client, "name") &&
      \ l:ui.client.name is# "Firenvim"
endfunction

function! OnUIEnter(event) abort
  if s:IsFirenvimActive(a:event)
    NERDTreeClose
    set showtabline=0
    set laststatus=0
    let g:airline#extensions#tabline#enabled = 0
    let g:dont_write = v:false
    function! My_Write(timer) abort
      let g:dont_write = v:false
      write
    endfunction

    function! Delay_My_Write() abort
      if g:dont_write
        return
      end
      let g:dont_write = v:true
      call timer_start(10000, 'My_Write')
    endfunction

    au TextChanged * ++nested call Delay_My_Write()
    au TextChangedI * ++nested call Delay_My_Write()
    " Always move the cursor at the end of the last character in insert mode
    au BufWritePost *.txt ++once call timer_start(100, {_ -> feedkeys("GA")})
  endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))

" Load .init.vim when writing {{{
augroup myvimrc
  au!
  au BufWritePost init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}

