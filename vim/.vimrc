" vim: foldmethod=marker foldlevel=0 foldenable

" Set encoding be described before :scriptencoding.
set encoding=utf-8
" File encoding
scriptencoding utf-8

" vim-plug (Vim Plugin Manager)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup installPlug
    autocmd!
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

" Plugins {{{
call plug#begin('~/.vim/plugged')
  " Editorconfig plugin for vim
  Plug 'editorconfig/editorconfig-vim'
  " Make terminal vim and tmux work better together
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " Better start screen
  Plug 'mhinz/vim-startify'
  " Molokai theme
  Plug 'tomasr/molokai'
  " Status line theme generator
  Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
  "Tmux theme generator
  Plug 'edkolev/tmuxline.vim'
  " Vertical lines for each indentation level
  Plug 'yggdroot/indentline'
  " Extended f, F, t and T key mappings for Vim
  Plug 'rhysd/clever-f.vim'
  " Highlight yank region
  Plug 'machakann/vim-highlightedyank'
  " Only update fold when be necessary
  Plug 'Konfekt/FastFold'
  " Insert or delete brackets, parens, quotes in pair
  Plug 'jiangmiao/auto-pairs'
  " End certain structures automatically
  Plug 'tpope/vim-endwise'
  " Diff level of parentheses in diff color
  Plug 'luochen1990/rainbow'
  " Improved incremental searching
  Plug 'haya14busa/incsearch-easymotion.vim' | Plug 'haya14busa/incsearch.vim' | Plug 'easymotion/vim-easymotion'
  " Improved incremental searching
  Plug 'haya14busa/incsearch-fuzzy.vim' | Plug 'haya14busa/incsearch.vim'
  " :substitute preview
  Plug 'osyo-manga/vim-over'
  " Highlights trailing whitespace in red and provides :FixWhitespace to fix it
  Plug 'bronson/vim-trailing-whitespace'
  " Highlight colors in css files
  Plug 'ap/vim-css-color'
  " Configuration for HTML
  "Plug 'othree/html5.vim' (vim-poliglot)
  " HTML tags generator
  Plug 'mattn/emmet-vim'
  " endings for html, xml, etc. - enhance vim-surround
  Plug 'tpope/vim-ragtag'
  "Ansi escape color sequences to color with :AnsiEsc
  Plug 'powerman/vim-plugin-AnsiEsc'
  "git diff in the gutter (sign column) and stages/undoes hunks
  Plug 'airblade/vim-gitgutter'
  " A tree explorer plugin with git info
  Plug 'Xuyuanp/nerdtree-git-plugin' | Plug 'scrooloose/nerdtree'
  " A tree explorer plugin with tabs
  Plug 'jistr/vim-nerdtree-tabs' | Plug 'scrooloose/nerdtree'
  "Extra syntax and highlight for nerdtree files
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight' | Plug 'scrooloose/nerdtree'
  " Git wrapper
  Plug 'tpope/vim-fugitive'
  " Syntax checking hacks
  "Plug 'vim-syntastic/syntastic'
  "mappings to easily delete, change and add such surroundings in pairs
  Plug 'tpope/vim-surround'
  " autopep8 python code
  "Plug 'tell-k/vim-autopep8' (vim-poliglot)
  " Ruby Configuration Files
  "Plug 'vim-ruby/vim-ruby' (vim-poliglot)
  " Crystal Configuration Files
  "Plug 'rhysd/vim-crystal' (vim-poliglot)
  " Elixir Configuration Files
  "Plug 'elixir-lang/vim-elixir' (vim-poliglot)
  " CSV files
  Plug 'chrisbra/csv.vim'
  " Dockerfiles
  "Plug 'ekalinin/Dockerfile.vim' (vim-poliglot)
  " Vastly improved Javascript indentation and syntax support
  Plug 'pangloss/vim-javascript'
  "Tern-based JavaScript editing support
  "Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
  " Text filtering and alignment
  "Plug 'godlygeek/tabular'
  " Align text
  Plug 'junegunn/vim-easy-align'
  " Visualize your Vim undo tree
  "Plug 'sjl/gundo.vim'
  Plug 'mbbill/undotree'
  " Better use visual block and search
  " https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
  "Plug 'terryma/vim-multiple-cursors'
  " Transition between multiline and single-line
  Plug 'AndrewRadev/splitjoin.vim'
  " To work with R
  Plug 'jalvesaq/Nvim-R'
  "Instant Markdown previews
  "Plug 'suan/vim-instant-markdown', { 'do': 'yarn global add instant-markdown-d'}
  "Plug 'shime/vim-livedown', { 'do': 'yarn global add livedown' }
  "enable repeating supported plugin maps with dot
  Plug 'tpope/vim-repeat'
  " Using vim-matchup plugin: a modern matchit and matchparen replacement
  Plug 'andymass/vim-matchup'
  " fzf inside vim
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  " Search and display information (Most Recent Used files)
  "Plug 'shougo/neomru.vim' | Plug 'shougo/unite.vim'
  " Search and display information (History yank)
  "Plug 'shougo/neoyank.vim' | Plug 'shougo/unite.vim'
  " Interact with tmux
  Plug 'benmills/vimux'
  " Seamless navigation between tmux panes and vim splits
  Plug 'christoomey/vim-tmux-navigator'
  " Enters in insert mode
  "Plug 'dahu/Insertlessly'
  " Additional text objects
  Plug 'wellle/targets.vim'
  " Syntax for tmux.conf
  "Plug 'tmux-plugins/vim-tmux' (vim-poliglot)
  " Haml, Sass, SCSS
  "Plug 'tpope/vim-haml' (vim-poliglot)
  " Editing LaTeX files
  Plug 'lervag/vimtex'
  " Visually select increasingly larger regions of text using the same key combination
  Plug 'terryma/vim-expand-region'
  " For running ruby tests
  Plug 'skalnik/vim-vroom'
  " Custom text object for selecting ruby blocks
  "Plug 'nelstrom/vim-textobj-rubyblock' | Plug 'kana/vim-textobj-user'
  " Transition between multiline and single-line code
  Plug 'AndrewRadev/splitjoin.vim'
  " ag searcher
  Plug 'mileszs/ack.vim'
  " Syntax for nix
  "Plug 'LnL7/vim-nix' (vim-poliglot)
  " Commenting code efficiently
  Plug 'scrooloose/nerdcommenter'
  " Interactive command execution
  Plug 'shougo/vimproc.vim', { 'do': 'make' }
  " Autocompletion
  Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang --gocode-completer --js-completer --racer-completer'}
  " The ultimate snippet solution
  Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets'
  " make YCM tab compatible with UltiSnips (using supertab)
  Plug 'ervandew/supertab'
  " Ruby code completion
  "Plug 'osyo-manga/vim-monster'
  " Intelligently toggling line numbers
  Plug 'myusuf3/numbers.vim'
  " CamelCase motion
  "Plug 'bkad/CamelCaseMotion'
  " CamelCase motion
  Plug 'chaoren/vim-wordmotion'
  " Tags in a window, ordered by scope
  Plug 'majutsushi/tagbar'
  " Configuration for Rust
  "Plug 'rust-lang/rust.vim' (vim-poliglot)
  " Configuration for Go
  "Plug 'fatih/vim-go' (vim-poliglot)
  " Configuration for Julia
  "Plug 'JuliaEditorSupport/julia-vim' (vim-poliglot)
  " Helpers for UNIX
  Plug 'tpope/vim-eunuch'
  " spelling tool better than spell
  Plug 'dpelle/vim-LanguageTool'
  " Rethinking Vim as a tool for writing
  Plug 'reedes/vim-pencil'
  " Asynchronous Lint Engine
  Plug 'w0rp/ale'
  " Persistent sessions
  Plug 'tpope/vim-obsession'
  " Autosave
  "Plug '907th/vim-auto-save'
  " Configuration for .vimfrc (vim-polyglot)
  "Plug 'vifm/vifm.vim'
  " A solid language pack for Vim.
  Plug 'sheerun/vim-polyglot'
  " Text object, based on indentation levels
  Plug 'michaeljsmith/vim-indent-object'
  " Adds file type glyphs/icons (should be put at last!!)
  Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}

" config {{{
" Poliglot forbidden language plugins
let g:polyglot_disabled = ['latex', 'r-lang']
" Increase timeout for installing YouCompleteMe
let g:plug_timeout = 10000

" http://vimawesome.com/
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" https://github.com/neovim/neovim/issues/2676
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" Optimize rendering
set lazyredraw
set ttyfast
" No compatibility with vi (already by default if .vimrc exist)
"set no compatible
" use the system clipboard
set clipboard^=unnamedplus,unnamed
" Filetype detection and load its plugins and indentation
filetype plugin indent on
" Syntax highlighting
syntax on
" Not use swap files
set noswapfile
" 256 colors in terminal
set t_Co=256
" Molokai theme
colorscheme molokai
" Molokai theme for the status line
let g:airline_theme = 'molokai'
" Enable powerline fonts
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Don't rewrite tmux theme
let g:airline#extensions#tmuxline#enabled = 0
" Change from a buffer without written changes
set hidden
" Visual column at 80
set colorcolumn=80
" Mapping delays
set timeoutlen=1000
" No timeout when typing leader key
set ttimeout
" Key code delays (perhaps 0?)
set ttimeoutlen=100
" Enable rainbow plugin
let g:rainbow_active = 1
" Enable numbers
set number
" Enable relativenumbers
set relativenumber
" Enable spelling checker when be necessary
"set spell
" Highlight the searched word
set hlsearch
" Search word while typing
set incsearch
" Ingnore case when searching
set ignorecase
" Case sensitive only with an uppercase letter
set smartcase
"set smarttab Tabs only for indent spaces for the rest
" Tabs became spaces
set expandtab
" 2 spaces for tab
set tabstop=2
"2 spaces for indentation
set shiftwidth=2
" Feel spaces as real tabs
set softtabstop=2
" Automatically inserts one extra level of indentation in some cases
"set smartindent
" Copy the indentation of the previous line
set autoindent
" Indent wrapped lines
set breakindent
" Show spaces, tabs and breaklines with characters using :set list
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
" Show this in wrapped lines
let &showbreak = '↳ '
" Wrap lines
set wrap
" showbreak in linenumbers column (no working perhaps by numbers plugin)
set cpoptions+=n
" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0
" comments | enable 'gq' | textwidth
set formatoptions=cqt
" Remove comment leader when joining lines
set formatoptions+=j
" Wrap lines at breakat
set linebreak
" List disables linebreak
set nolist
"Highlight the current line
set cursorline
" Enable read vim options in any file
set modeline
" Extends % funcionality
" using vim-matchup plugin: a modern matchit and matchparen replacement
" runtime! macros/matchit.vim
" Number of commands in :history
set history=10000
" Max opened tabs
set tabpagemax=50
" Enable completion
set omnifunc=syntaxcomplete#Complete
" delete over line breaks, automatically-inserted indentation, place where insert mode started
set backspace=indent,eol,start
" Tags file instead of scanning includes
set complete-=i
" Increase numbers like 0X as decimals
set nrformats-=octal
" Status line
set laststatus=2
" In the right side of the status line: line number, column number, virtual column number, relative position
set ruler
" Break plugins: Search recursive with :find and tab-completion for all file related task
" set path+=**
" Complete commands
set wildmenu
" Complete to the longest common string and invoke wildmenu
set wildmode=longest:full,full
" Enable mouse in all modes
set mouse=a
" Reload file after external command like !ls
set autoread
au WinEnter,BufWinEnter,FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
" Reload file when the focus is gained
au WinEnter,BufWinEnter,FocusGained,BufEnter,CursorHold,CursorHoldI * :silent! !
" Write file when the focus is lost
au FocusLost,WinLeave * :silent! w
" Show the current command when typing it at status line
set showcmd
" Never remember global options
set sessionoptions-=options
" Never hide symbols
set conceallevel=0
set concealcursor=

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Keep undo history across sessions by storing it in a file
set undofile
call system('mkdir -p /tmp/.vim_undo')
set undodir=/tmp/.vim_undo
" }}}
nmap <Esc> <Plug>(clever-f-reset)
" Highlight yank region
map y <Plug>(highlightedyank)
" monokai visual colors
hi HighlightedyankRegion ctermbg=235 guibg=#403D3D
let g:highlightedyank_highlight_duration = 300
" Write file and create the folder if not exists
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let l:dir=fnamemodify(a:file, ':h')
        if !isdirectory(l:dir)
            call mkdir(l:dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Substitute preview
nnoremap <Leader>s :OverCommandLine<CR>

" Ale config {{{
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:ale_dockerfile_hadolint_use_docker = 'yes'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '%severity%  [%linter%]: %s'
" }}}

" CamelCase motion {{{
"map <silent> w <Plug>CamelCaseMotion_w
"map <silent> b <Plug>CamelCaseMotion_b
"map <silent> e <Plug>CamelCaseMotion_e
"map <silent> ge <Plug>CamelCaseMotion_ge
"sunmap w
"sunmap b
"sunmap e
"sunmap ge
"}}}
" clever-f.vim better
" In motions f, F, t, T swap ; with , because spanish keyboard
"nnoremap ; ,
"nnoremap , ;
" Insert mode: ctrl+U for undoing
inoremap <C-U> <C-G>u<C-U>

" FZF Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Folding settings {{{
" Folds opened by default
set nofoldenable
set foldlevel=0
"https://github.com/Konfekt/FastFold
let g:fastfold_savehook=0
" fold based on indent
set foldmethod=indent
"deepest fold is 10 levels
"set foldnestmax=10
" }}}
" Search incremental with easymotion {{{
":call incsearch#call(incsearch#config#easymotion#make())
map /  <Plug>(incsearch-easymotion-/)
map ?  <Plug>(incsearch-easymotion-?)
map g/ <Plug>(incsearch-easymotion-stay)
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
"}}}
" Esc Esc for Highlight off the searched term
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
" Never used this keys together so remap to esc
inoremap kj <esc>
inoremap jj <esc>
" Leader key
let g:mapleader = "\<Space>"
" Local leader key
let g:maplocalleader = ','
" Open .vimrc
nmap <silent> <Leader>ev :e $MYVIMRC<CR>
" Load .vimrc
nmap <silent> <Leader>sv :so $MYVIMRC<CR>
" Load .vimrc when writing
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" Highlight .vifmrc and theme files but don't enable because nerdtree is prefered
let g:loaded_vifm=1

" Unite plugin config {{{
" Open all
"nnoremap <Leader>u :Unite file/async file_rec/async buffer file_mru<CR>
" Open all horizontal mode
"nnoremap <Leader>us :Unite file/async file_rec/async buffer file_mru -default-action=split<CR>
" Open all vertical mode
"nnoremap <Leader>uv :Unite file/async file_rec/async buffer file_mru -default-action=vsplit<CR>
" Open buffer
"nnoremap <Leader>ub :Unite buffer<CR>
" Open buffer horizontal mode
"nnoremap <Leader>ubs :Unite buffer -default-action=split<CR>
" Open buffer vertical mode
"nnoremap <Leader>ubv :Unite buffer -default-action=vsplit<CR>
" Open search lines (ag)
"nnoremap <Leader>ul :Unite line<CR>
" Open search lines (ag) horizontal mode
"nnoremap <Leader>uls :Unite line -default-action=split<CR>
" Open search lines (ag) vertical mode
"nnoremap <Leader>ulv :Unite line -default-action=vsplit<CR>
" Open yank buffer
"let g:unite_source_history_yank_enable = 1
"nnoremap <Leader>uy :Unite history/yank<CR>
" Open command buffer
"nnoremap <Leader>uc :Unite command<CR>
" Open ag to the target folder with the pattern chosen
"let g:unite_source_grep_command = 'ag'
"let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden'
"let g:unite_source_grep_recursive_opt = ''
"let g:unite_source_grep_encoding = 'utf-8'
"nnoremap <Leader>ag :Unite grep<CR>
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#filters#sorter_default#use(['sorter_length'])
"let g:unite_source_rec_max_cache_files=9999
"let g:unite_source_rec_async_command='ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""'
" }}}
let g:NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
map <Leader>n :NERDTreeToggle<CR>
map <Leader>n. :NERDTreeFind<CR>
map <Leader>t :TagbarToggle<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :e<Space>
nnoremap <Leader>wq :w<CR>:q<CR>
nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wv <C-w>v
nmap <Leader>y "+y
vmap <Leader>y "+y
nmap <Leader>yy "+yy
nmap <Leader>d "+d
vmap <Leader>d "+d
nmap <Leader>dd "+dd
nmap <Leader>p "+p
vmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>P "+P
nmap <Leader><Leader> V
"map K <Plug>(expand_region_expand)
"map J <Plug>(expand_region_shrink)
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
" Make a simple "search" text object.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>
map sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" Remove cowsay from startify
let g:startify_custom_header = []

" HTML extras
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key='<C-E>'
autocmd FileType html,css EmmetInstall
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" Never conceal markdown by default with indentLine
autocmd BufNewFile,BufReadPost *.md let indentLine_enabled=0
" Use vmd as default build command for Markdown files
function! Markdown_viewer()
  silent! execute "!ps aux | fgrep vmd | grep -Fv grep > /dev/null || vmd '%:p' &"
endfunction
au BufReadPost,BufNewFile *.md call Markdown_viewer()

"autocmd FileType ruby compiler ruby
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"let g:monster#completion#rcodetools#backend = "async_rct_complete"
"let g:neocomplete#sources#omni#input_patterns = {
"   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
"}
" Crystal
let g:crystal_auto_format = 1
" Show all latex commands
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:markdown_syntax_conceal =  0
let g:vim_json_syntax_conceal = 0
let g:indentLine_setConceal = 0

" Never conceal
set conceallevel=0
au FileType * setl conceallevel=0

" Open CSV and TSV files and format columns automatically {{{
" Analize only the first 100 lines to determine which delimiter use
let g:csv_start = 1
let g:csv_end = 100
autocmd FileType csv,tsv set norelativenumber
aug CSV_Editing
  au!
  au BufRead,BufWritePost *.csv,*.tsv :%ArrangeColumn
  au BufWritePre *.csv,*.tsv :%UnArrangeColumn
aug end
" }}}

" Save buffer after move the focus to other pane
let g:tmux_navigator_save_on_switch = 1

" Syntastic plugin config {{{
" https://stackoverflow.com/a/22253548
" YouCompleteMe with Tab
" make YCM compatible with UltiSnips (using supertab)
" Completion in comments
let g:ycm_complete_in_comments = 1
" Completion with tags
let g:ycm_collect_identifiers_from_tags_files = 1
" Complete default language keywords
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_key_list_select_completion   = ['<tab>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<s-tab>', '<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:endwise_no_mappings = 1
" https://github.com/SirVer/ultisnips/issues/376#issuecomment-69033351
let g:UltiSnipsExpandTrigger='<nop>'
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
  let l:snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return l:snippet
  else
    return "\<CR>"
  endif
endfunction
" https://github.com/SirVer/ultisnips/issues/376#issuecomment-201977560
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR>"
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'


" Git Gutter {{{
" Symbols react faster
" https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
set updatetime=100
let g:gitgutter_grep = 'rg'
let g:gitgutter_sign_removed = '-'
" Symbols color
highlight GitGutterAdd ctermfg=green ctermbg=235
highlight GitGutterChange ctermfg=yellow ctermbg=235
highlight GitGutterDelete ctermfg=red ctermbg=235
highlight GitGutterChangeDelete ctermfg=yellow ctermbg=235
" Move between hunks
nmap <localleader>k <Plug>GitGutterPrevHunk
nmap <localleader>j <Plug>GitGutterNextHunk
" Stage and undo hunks without git add --patch
nmap <Leader>s <Plug>GitGutterStageHunk
nmap <Leader>u <Plug>GitGutterUndoHunk
" }}}

" Git commands {{{
nmap <leader>gc :Gread<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>
" }}}

" Diff commands {{{
" If doing a diff. Upon writing changes to file, automatically update the
" differences
autocmd BufWritePost * if &diff == 1 | diffupdate | endif
autocmd InsertEnter  * if &diff == 1 | diffupdate | endif
autocmd InsertChange * if &diff == 1 | diffupdate | endif
autocmd InsertLeave  * if &diff == 1 | diffupdate | endif

nmap <localleader>k [c<bar>:diffupdate<CR>
nmap <localleader>j ]c<bar>:diffupdate<CR>
nmap <localleader>u :diffupdate<CR>
" do          - diffobtain
" dp          - diffput
" ]c          - next difference
" [c          - previous difference
" :diffupdate - re-scan the files for differences
" zo          - unfold/unhide text
" zc          - refold/rehide text
" zr          - unfold both files completely
" zm          - fold both files completely
" }}}

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
xmap ga <Plug>(EasyAlign)

" Tabular plugin config {{{
"vmap <leader>t= :Tabularize /=<CR>
"vmap <leader>t: :Tabularize /::<CR>
"vmap <leader>t- :Tabularize /-><CR>
" }}}

let g:rustfmt_autosave = 1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:ackprg = 'rg --vimgrep'
cnoreabbrev ag Ack
cnoreabbrev rg Ack

" Buffers {{{
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <Leader>b :enew<cr>
" Move to the next buffer
nmap <Leader>l :bnext<CR>
" Move to the previous buffer
nmap <Leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <Leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <Leader>bl :ls<CR>

nmap <Leader>T :tabnew<CR>
" }}}

" Autosave {{{
"let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_silent = 1  " do not display the auto-save notification
"let g:auto_save_events = ["InsertLeave", "TextChanged"] " will save on every change in normal mode and every time you leave insert mode
" }}}

"autocmd FileType vim setlocal foldmethod=marker foldlevel=0
"let g:languagetool_jar = '/usr/share/java/languagetool/languagetool-commandline.jar'
let g:languagetool_jar = '$HOME/languagetool/languagetool-standalone/target/LanguageTool-3.7-SNAPSHOT/LanguageTool-3.7-SNAPSHOT/languagetool-commandline.jar'
let g:languagetool_lang = 'en-US'

"let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
"augroup pencil
  "autocmd!
  "autocmd FileType markdown,mkd call pencil#init()
  "autocmd FileType tex call pencil#init()
  "autocmd FileType text         call pencil#init({'wrap': 'hard'})
"augroup END

" https://github.com/junegunn/fzf.vim
" FZF Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Go to the next ALE report
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
nmap <silent> <leader>j <Plug>(ale_next_wrap)
