" vim: foldmethod=marker foldlevel=0 foldenable

" Set encoding be described before :scriptencoding.
set encoding=utf-8
" File encoding
scriptencoding utf-8

" vim-plug (Vim Plugin Manager) {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup installPlug
    autocmd!
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif
" }}}

" helper function to select in vim/nvim only {{{
" Example: " Plug 'iamcco/markdown-preview.vim',  Cond(!has('nvim'))
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
" }}}

" Plugins {{{
call plug#begin('~/.vim/plugged')
  " Editorconfig plugin for vim
  Plug 'editorconfig/editorconfig-vim'
  " Automatically reload a file that has changed externally
  Plug 'djoshea/vim-autoread'
  " Make terminal vim and tmux work better together
  Plug 'tmux-plugins/vim-tmux-focus-events'
  " Better start screen
  Plug 'mhinz/vim-startify'
  " Molokai theme
  Plug 'tomasr/molokai'
  " Status line theme generator
  Plug 'vim-airline/vim-airline' | Plug 'mimadrid/vim-airline-themes'
  "Tmux theme generator
  Plug 'edkolev/tmuxline.vim'
  " Vertical lines for each indentation level
  Plug 'nathanaelkane/vim-indent-guides'
  " Extended f, F, t and T key mappings for Vim
  Plug 'rhysd/clever-f.vim'
  " Highlight yank region
  Plug 'machakann/vim-highlightedyank'
  " Selectively illuminating other uses of the current word under the cursor
  Plug 'RRethy/vim-illuminate'
  " Make scrolling in Vim more pleasant
  Plug 'terryma/vim-smooth-scroll'
  " Only update fold when be necessary
  Plug 'Konfekt/FastFold'
  " Insert or delete brackets, parens, quotes in pair
  Plug 'jiangmiao/auto-pairs'
  " End certain structures automatically
  Plug 'tpope/vim-endwise'
  " Edit registers/macros and lists as buffers (c@register in normal mode)
  Plug 'rbong/vim-buffest'
  " Coertion between: Press gs + snake_case(s), MixedCase(m), CamelCase(c), UPPER_CASE(u), dash-case(-), dot.case(.), space case(space) and Title Case(t)
  Plug 'arthurxavierx/vim-caser'
  " Multiple cursor selections
  Plug 'terryma/vim-multiple-cursors'
  " Operator motions to quickly replace text
  Plug 'svermeulen/vim-subversive'
  " Diff level of parentheses in diff color
  Plug 'luochen1990/rainbow'
  " Improved incremental searching
  Plug 'haya14busa/incsearch-easymotion.vim' | Plug 'haya14busa/incsearch.vim' | Plug 'easymotion/vim-easymotion'
  " Improved incremental searching
  Plug 'haya14busa/incsearch-fuzzy.vim' | Plug 'haya14busa/incsearch.vim'
  " Display number of search matches & index of a current match
  Plug 'google/vim-searchindex'
  " :substitute preview
  Plug 'osyo-manga/vim-over'
  " Highlights trailing whitespace in red and provides :FixWhitespace to fix it
  Plug 'bronson/vim-trailing-whitespace'
  " Open file with line and column associated (vim/:e[edit]/gF path/to/file.ext:12:3)
  Plug 'wsdjeg/vim-fetch'
  " Plugin to move lines and selections up and down
  Plug 'matze/vim-move'
  " Open devdocs.io from Vim
  Plug 'rhysd/devdocs.vim'
  " Highlight colors in css files
  Plug 'ap/vim-css-color'
  " Simple color selector/picker
  Plug 'KabbAmine/vCoolor.vim'
  " Configuration for HTML
  "Plug 'othree/html5.vim' (vim-polyglot)
  " HTML tags generator
  Plug 'mattn/emmet-vim'
  " endings for html, xml, etc. - enhance vim-surround
  Plug 'tpope/vim-ragtag'
  "Ansi escape color sequences to color with :AnsiEsc
  Plug 'powerman/vim-plugin-AnsiEsc'
  " An alternative sudo.vim
  Plug 'lambdalisue/suda.vim'
  " Git helper for vim
  Plug 'tpope/vim-fugitive'
  "git diff in the gutter (sign column) and stages/undoes hunks
  Plug 'airblade/vim-gitgutter'
  " A Vim plugin for more pleasant editing on commit messages
  Plug 'rhysd/committia.vim'
  " Input completion for GitHub
  Plug 'rhysd/github-complete.vim'
  " Use of vifm as a file picker
  Plug 'vifm/vifm.vim'
  " A tree explorer plugin with git info
  Plug 'Xuyuanp/nerdtree-git-plugin' | Plug 'scrooloose/nerdtree'
  " A tree explorer plugin with tabs
  Plug 'jistr/vim-nerdtree-tabs' | Plug 'scrooloose/nerdtree'
  "Extra syntax and highlight for nerdtree files
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight' | Plug 'scrooloose/nerdtree'
  " Syntax checking hacks
  "Plug 'vim-syntastic/syntastic'
  "mappings to easily delete, change and add such surroundings in pairs
  Plug 'tpope/vim-surround'
  " Plugin to toggle, display and navigate marks
  Plug 'kshenoy/vim-signature'
  " Run your tests at the speed of thought
  Plug 'janko-m/vim-test'
  " autopep8 python code
  "Plug 'tell-k/vim-autopep8' (vim-polyglot)
  " Ruby Configuration Files
  "Plug 'vim-ruby/vim-ruby' (vim-polyglot)
  " Crystal Configuration Files
  "Plug 'rhysd/vim-crystal' (vim-polyglot)
  " Elixir Configuration Files
  "Plug 'elixir-lang/vim-elixir' (vim-polyglot)
  " CSV files
  " Plug 'chrisbra/csv.vim'  (vim-polyglot)
  " Dockerfiles
  "Plug 'ekalinin/Dockerfile.vim' (vim-polyglot)
  " Vastly improved Javascript indentation and syntax support
  " Plug 'pangloss/vim-javascript' "(vim-polyglot)
  " Typescript syntax files for Vim
  Plug 'leafgarland/typescript-vim'
  " React JSX/TSX syntax pretty highlighting for vim
  Plug 'maxmellon/vim-jsx-pretty'
  " Text filtering and alignment
  "Plug 'godlygeek/tabular'
  " Align text
  Plug 'junegunn/vim-easy-align'
  " Visualize your Vim undo tree
  "Plug 'sjl/gundo.vim'
  Plug 'mbbill/undotree'
  " Transition between multiline and single-line
  Plug 'AndrewRadev/splitjoin.vim'
  " To work with R
  Plug 'jalvesaq/Nvim-R'
  " R autocompletion
  Plug 'gaalcaras/ncm-R'
  "enable repeating supported plugin maps with dot
  Plug 'tpope/vim-repeat'
  " Using vim-matchup plugin: a modern matchit and matchparen replacement
  Plug 'andymass/vim-matchup'
  " fzf inside vim
  Plug 'junegunn/fzf.vim'
  " Interact with tmux
  Plug 'benmills/vimux'
  " Seamless navigation between tmux panes and vim splits
  Plug 'christoomey/vim-tmux-navigator'
  " Enters in insert mode
  "Plug 'dahu/Insertlessly'
  " Additional text objects
  Plug 'wellle/targets.vim'
  " Real-time markdown preview plugin
  Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'}
  " Syntax for tmux.conf
  "Plug 'tmux-plugins/vim-tmux' (vim-polyglot)
  " Haml, Sass, SCSS
  "Plug 'tpope/vim-haml' (vim-polyglot)
  " Editing LaTeX files
  Plug 'lervag/vimtex'
  " Visually select increasingly larger regions of text using the same key combination
  Plug 'terryma/vim-expand-region'
  " Custom text object for selecting ruby blocks
  "Plug 'nelstrom/vim-textobj-rubyblock' | Plug 'kana/vim-textobj-user'
  " Transition between multiline and single-line code
  Plug 'AndrewRadev/splitjoin.vim'
  " Syntax for nix
  "Plug 'LnL7/vim-nix' (vim-polyglot)
  " Commenting code efficiently
  Plug 'tomtom/tcomment_vim'
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
  Plug 'chaoren/vim-wordmotion'
  " Tags in a window, ordered by scope
  Plug 'majutsushi/tagbar'
  " Configuration for Rust
  "Plug 'rust-lang/rust.vim' (vim-polyglot)
  " Configuration for Go
  "Plug 'fatih/vim-go' (vim-polyglot)
  " Configuration for Julia
  "Plug 'JuliaEditorSupport/julia-vim' (vim-polyglot)
  " Helpers for UNIX
  Plug 'tpope/vim-eunuch'
  " Language tool grammar check
  Plug 'rhysd/vim-grammarous'
  " Asynchronous Lint Engine
  Plug 'w0rp/ale'
  " Plugin for formatting code
  Plug 'sbdchd/neoformat'
  " Persistent sessions
  Plug 'tpope/vim-obsession'
  " Autosave
  "Plug '907th/vim-auto-save'
  " A solid language pack for Vim.
  Plug 'sheerun/vim-polyglot'
  " Text object, based on indentation levels
  Plug 'michaeljsmith/vim-indent-object'
  " Markdown improvements like TOC
  Plug 'SidOfc/mkdx'
  " Adds file type glyphs/icons (should be put at last!!)
  Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}

" config {{{
" Leader key
let g:mapleader = "\<Space>"
" Local leader key
let g:maplocalleader = ','

" Polyglot forbidden language plugins
let g:polyglot_disabled = ['latex', 'r-lang', 'markdown']
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
" Use 24-bit colors
set termguicolors
" Molokai theme
colorscheme molokai
" Molokai theme for the status line
let g:airline_theme = 'molokai'
let g:airline_molokai_bright=1
" Enable powerline fonts
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Don't rewrite tmux theme
let g:airline#extensions#tmuxline#enabled = 0
" Use buffer filename as tmux window name
autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
" Reset tmux windows name when exit
autocmd VimLeave * call system("tmux setw automatic-rename")
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
" Enable spell en_us by default
set spell
set spelllang=en_us
" Autocomplete with dictionary words
set complete+=kspell
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
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵,space:·
" Show this in wrapped lines
let &showbreak = '↳ '
" Wrap lines
set wrap
" showbreak in linenumbers column (no working perhaps by numbers plugin)
set cpoptions+=n
" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0
" Remove Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode behaviour
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
" https://vi.stackexchange.com/a/1985
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
" Force to set formatoptions for each type of files
au FileType * set fo-=c fo-=r fo-=o
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
" Complete commands/folders
" Folder navigation https://xaizek.github.io/2012-10-08/vim-wild-menu/
set wildmenu
" Complete to the longest common string and invoke wildmenu
set wildmode=longest:full,full
" Complete ingnoring case sensitive
set wildignorecase
" Enable mouse in all modes
set mouse=a
" Reload file after external command like !ls
set autoread
" Write file when the focus is lost
au FocusLost,WinLeave * :silent! w
" Write the contents of the file, if it has been modified
set autowriteall
" Show the current command when typing it at status line
set showcmd
" Never remember global options
set sessionoptions-=options
" Never hide symbols
set conceallevel=0
set concealcursor=
" Keep undo history across sessions by storing it in a file
set undofile
call system('mkdir -p /tmp/.vim_undo')
set undodir=/tmp/.vim_undo
" }}}

" Inner entire buffer
onoremap ib :exec "normal! ggVG"<cr>
vnoremap ib ggG
" Current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>

" clever-f.vim {{{
nmap <Esc> <Plug>(clever-f-reset)
let g:clever_f_show_prompt = 1
let g:clever_f_mark_char   = 1
" }}}

" Vim subversive {{{
" s for substitute
nmap s <Plug>(SubversiveSubstitute)
nmap ss <Plug>(SubversiveSubstituteLine)
nmap S <Plug>(SubversiveSubstituteToEndOfLine)
xmap <localleader>s <Plug>(SubversiveSubstituteRange)
nmap <localleader>s <Plug>(SubversiveSubstituteRange)
nmap <localleader>ss <Plug>(SubversiveSubstituteWordRange)
nmap <localleader>cr <Plug>(SubversiveSubstituteRangeConfirm)
xmap <localleader>cr <Plug>(SubversiveSubstituteRangeConfirm)
nmap <localleader>crr <Plug>(SubversiveSubstituteWordRangeConfirm)
" }}}

" Send word under cursor to devdocs.io
nmap K <Plug>(devdocs-under-cursor)

" molokai colors improved {{{
highlight CursorLine   ctermbg=236 guibg=#403D3D
highlight CursorLineNr ctermbg=236 cterm=bold guibg=#232526 gui=bold
" Reduce highlighted time of the yank region
let g:highlightedyank_highlight_duration = 300
" }}}

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

" Substitute preview with Over {{{
" Fix incompatibility with vim-searchindex
" https://github.com/osyo-manga/vim-over/issues/60#issuecomment-339207149
let g:over#command_line#enable_import_commandline_map = 0
nnoremap <Leader>r :OverCommandLine<CR>%s/
xnoremap <Leader>r :OverCommandLine<CR>s/
" }}}


" Ale config {{{
let g:ale_linters = {'rust': ['rls']}
let g:ale_fixers = {
      \   'tex': ['latexindent'],
      \   'python': ['black'],
      \   'r': ['styler'],
      \   'sh': ['shfmt'],
      \   'typescript': ['tslint'],
      \ }
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = ' '
let g:airline#extensions#ale#warning_symbol = ' '
let g:airline#extensions#ale#show_line_numbers = 0
let g:ale_dockerfile_hadolint_use_docker = 'yes'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '%severity%  [%linter%]: %s'
highlight ALEWarning ctermfg=yellow ctermbg=236 guifg=yellow
highlight ALEError   ctermfg=red    ctermbg=236 guifg=red
highlight link ALEWarningSign ALEWarning
highlight link ALEErrorSign   ALEError
" }}}

" Neoformat config {{{
nnoremap <localleader>= :Neoformat<CR>
" }}}

" Insert mode: ctrl+U for undoing
inoremap <C-U> <C-G>u<C-U>

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

" Use ex mode map to call last macro instead
" Bram Moolenaar recommends mapping Q to something else
" To call ex map use the less error prone alias gQ
nnoremap Q @@

" Input command faster
nnoremap ; :
xnoremap ; :

" Use ZZ to save all buffer inclusive readonly and exit
nnoremap ZZ :xa!<CR>
inoremap ZZ <ESC>:xa!<CR>
nnoremap ZQ :qa!<CR>
inoremap ZQ <ESC>:qa!<CR>

" Esc Esc for Highlight off the searched term
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
" Never these keys combination are used together so remap to esc and cr
inoremap aa <esc>
inoremap ;; <cr>
" Open .vimrc
nmap <silent> <leader>ev :execute 'e ' . resolve(expand($MYVIMRC))<CR>
" Load .vimrc
nmap <silent> <Leader>sv :so $MYVIMRC<CR>
" Load .vimrc when writing
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" vifm config {{{
nnoremap <Leader>ve :EditVifm<CR>
nnoremap <Leader>vh :SplitVifm<CR>
nnoremap <Leader>vv :VsplitVifm<CR>
nnoremap <Leader>vd :DiffVifm<CR>
nnoremap <Leader>vt :TabVifm<CR>
" }}}


" NERDTree config {{{
let g:NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" NERDTree and Startify working at startup
autocmd VimEnter *
                \   if !argc()
                \ |   NERDTree
                \ |   wincmd l
                \ |   Startify
\ | endif

map <Leader>n :NERDTreeToggle<CR>
map <Leader>n. :NERDTreeFind<CR>
map <Leader>t :TagbarToggle<CR>
" }}}

" vim-smooth-scroll {{{
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
" }}}

nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :e<Space>
nnoremap <Leader>wq :w<CR>:q<CR>
nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wv <C-w>v
nnoremap <Leader>W :w suda://%<CR>
cnoremap w!! :w suda://%<CR>
xnoremap v V
nnoremap <Leader>= <esc>gg=G<C-o><C-o>
xnoremap <Leader>s :sort<CR>
"map K <Plug>(expand_region_expand)
"map J <Plug>(expand_region_shrink)

" It makes j and k move by wrapped line unless I had a count,
" in which case it behaves normally.
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
" When pasting don't update the register
xnoremap p pgvy
" Make a simple "search" text object.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Split line by delimiters (J inverted) {{{
function! SplitLine()
   let splitted_line = substitute(getline(line('.')), '\([,;.:]\)','\1\n', 'g')
   " substitute() doesn't print new lines
   " So the variable has to be printed using a register
   " The first step is backup any register
   let old_register = @l
   let @l = splitted_line
   " From normal mode to Visual Line mode and then paste the register
   normal! V"lp
   let @l = old_register
endfunction
nnoremap J :call SplitLine()<CR>
" }}}

" Use arrows to resize panels {{{
nnoremap <Up>    :resize -2<CR>
nnoremap <Down>  :resize +2<CR>
nnoremap <Left>  :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
" }}}

" Remove cowsay from startify
let g:startify_custom_header = []

" Emmet (HTML generation) {{{
" Enable emmet for any filetype
let g:user_emmet_install_global = 1
" Ctrl-E + , (to generate the html code for the text line)
let g:user_emmet_leader_key='<C-E>'
" Use emmet globally because html is usually embedded in practically any filetype
" autocmd FileType html,css,javascript,markdown,typescript EmmetInstall
" }}}

" indent guides {{{
let g:indent_guides_start_level = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#1c1c1c	 ctermbg=233
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#1c1c1c	 ctermbg=233
" }}}

" Color marks with gitgutter state
let g:SignatureMarkTextHLDynamic = 1

" Markdown improvements {{{
" markdown-preview plugin {{{
" Open the preview window once enter the markdown buffer
let g:mkdp_auto_start = 1
" }}}

" Open TOC using fzf instead of quickfix window {{{
fun! s:MkdxGoToHeader(header)
    " given a line: '  84: # Header'
    " this will match the number 84 and move the cursor to the start of that line
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    " if the text is empty or no lnum is present, return the empty string
    if (empty(text) || empty(lnum)) | return text | endif

    " We can't jump to it if we dont know the line number so that must be present in the outpt line.
    " We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>
" }}}
" :h mkdx-settings
let g:mkdx#settings =            {
      \ 'enter':                   { 'enable': 0},
      \ 'checkbox':                { 'toggles': [' ', 'X']},
      \ 'highlight':               { 'enable': 1 },
      \ 'toc':                     { 'text': "Table Of Content", 'list_token': '-',
      \                              'update_on_write': 0,
      \                              'position': 2,
      \                              'details': {
      \                                 'enable': 1,
      \                                 'summary': 'Click to expand {{toc.text}}'
      \                              }
      \                            }
\ }
" to keep it limited to markdown files, one can use an "autocommand".
" First, make sure we don't create the default mapping when entering markdown files.
" All plugs can be disabled like this (except insert mode ones, they need "imap" instead of "nmap").
nmap <Plug> <Plug>(mkdx-gen-or-upd-toc)

" then create a function to remap manually
fun! s:MkdxRemap()
    " regular map family can be used since these are buffer local.
    nmap <buffer><silent> <leader>i <Plug>(mkdx-gen-or-upd-toc)
    " other overrides go here
endfun

" finally, add a "FileType" autocommand that calls "s:MkdxRemap()" upon entering markdown filetype
augroup Mkdx
    au!
    au FileType markdown call s:MkdxRemap()
augroup END
" }}}
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
" https://blog.bugsnag.com/tmux-and-vim/
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>
" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>

" YouCompleteMe  {{{
" with Tab
" htps://stackoverflow.com/a/22253548
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
let g:ycm_min_num_of_chars_for_completion = 1
let g:UltiSnipsExpandTrigger='<tab>'
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
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1,
      \ 'i3':1,
      \ 'markdown':1,
      \ 'text': 1,
      \ 'tmux':1,
      \ 'vim': 1,
      \ 'yaml':1,
      \ 'zsh': 1,
      \}
let g:ycm_filetype_blacklist = {
      \ 'fzf': 1,
      \ 'infolog': 1,
      \ 'mail': 1,
      \ 'notes': 1,
      \ 'pandoc': 1,
      \ 'qf': 1,
      \ 'tagbar': 1,
      \ 'unite': 1,
      \ 'vimwiki': 1,
      \}
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
" }}}


" Git Gutter {{{
let g:gitgutter_grep = 'rg'
let g:gitgutter_sign_removed = '-'
" Symbols color
highlight GitGutterAdd          ctermfg=green  ctermbg=236 cterm=bold guifg=green  guibg=#232526 gui=bold
highlight GitGutterChange       ctermfg=yellow ctermbg=236 cterm=bold guifg=yellow guibg=#232526 gui=bold
highlight GitGutterDelete       ctermfg=red    ctermbg=236 cterm=bold guifg=red    guibg=#232526 gui=bold
highlight GitGutterChangeDelete ctermfg=yellow ctermbg=236 cterm=bold guifg=yellow guibg=#232526 gui=bold
" Move between hunks
nmap <localleader>k <Plug>GitGutterPrevHunk
nmap <localleader>j <Plug>GitGutterNextHunk
" Stage and undo hunks without git add --patch
nmap <Leader>s <Plug>GitGutterStageHunk
nmap <Leader>u <Plug>GitGutterUndoHunk
" Preview deleted hunk
nmap <Leader>p <Plug>GitGutterPreviewHunk
" Hunk object manipulation
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
" }}}

" Git fugitive commands {{{
nmap <leader>gc :Gcommit<CR>i
nmap <leader>gco :Gread<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>
" }}}

nmap <leader>ti :terminal ++curwin ++close tig<cr>

" vim-test config {{{
nnoremap <silent> <Leader>tn :TestNearest<CR>
nnoremap <silent> <Leader>tf :TestFile<CR>
nnoremap <silent> <Leader>ts :TestSuite<CR>
nnoremap <silent> <Leader>tl :TestLast<CR>
nnoremap <silent> <Leader>tv :TestVisit<CR>
" }}}

" Always open git commit files in insert mode
autocmd FileType gitcommit exec 'au VimEnter * startinsert'

" Diff commands {{{
" Better diff options {{{
" Use histogram diff algorithm
set diffopt+=algorithm:histogram
" Use default git diff heuristic
set diffopt+=indent-heuristic
" }}}
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
" 1do         - diffobtain LOCAL
" 2do         - diffobtain BASE
" 3do         - diffobtain REMOTE
" dp          - diffput
" ]c          - next difference
" [c          - previous difference
" :diffupdate - re-scan the files for differences
" zo          - unfold/unhide text
" zc          - refold/rehide text
" zr          - unfold both files completely
" zm          - fold both files completely
if &diff
  " get chunk from LOCAL
  nmap <localleader>1 :diffget LOCAL<CR>
  " get chunk from BASE
  nmap <localleader>2 :diffget BASE<CR>
  " get chunk from REMOTE
  nmap <localleader>3 :diffget REMOTE<CR>
endif
" }}}

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
xmap ga <Plug>(EasyAlign)

" color selector {{{
let g:vcoolor_disable_mappings = 1
" It breaks space as leader key because vcoolor also map keys in insert mode
" let g:vcoolor_map = '<Leader>c'
nnoremap <leader>c :VCoolor<CR>
" }}}

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

" Nvim-R related config {{{
" Display console and Object browser when any .R file is opened like RStudio
augroup NvimrR
    autocmd!
    autocmd! FileType r :call InitNvimR()
augroup END
function InitNvimR()
  call StartR("R")
  " sleep 1500m
  " call RObjBrowser()
  " iabbrev <buffer> -- <-
endfunction
" Use rtichoke as the default R terminal
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_args = []  " if you had set any
let R_bracketed_paste = 1
" Always use horizontal R console
let R_rconsole_width = 0
let R_rconsole_height = 15
" Always use horizontal R help
let R_nvimpager = 'tab'
" Enable vi mode in R console
let R_esc_term = 0
" R commands in the R output are highlighted
let Rout_more_colors = 1
" R output is highlighted using you current
let rout_follow_colorscheme = 1
" Display dataframes closed by default
let R_objbr_opendf = 0
" Remove underscore convertion to <-
let R_assign = 0
" Run R in a terminal emulator
let R_in_buffer = 0
" Custom the call to the terminal emulator
let R_term_cmd = 'alacritty --title "R: ' . expand("%:t") . '" --command'

" Object_Browser window highlight endline tabs by default
" Ignore extra whitespace by filetype doesn't work
" let g:extra_whitespace_ignored_filetypes = ['rbrowser']
" So force to turn off with the :highlight command
autocmd FileType rbrowser :highlight ExtraWhitespace ctermbg=none

" }}}

" Buffers {{{
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <Leader>b :enew<cr>
" Delete current buffer
nmap <Leader>d :bd<cr>
" Move to the next buffer
nmap <Leader>l :bnext<CR>
" Move to the previous buffer
nmap <Leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <Leader>bq :bp <BAR> bd #<CR>
nmap <Leader>T :tabnew<CR>
" }}}

" Autosave {{{
"let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_silent = 1  " do not display the auto-save notification
"let g:auto_save_events = ["InsertLeave", "TextChanged"] " will save on every change in normal mode and every time you leave insert mode
" }}}

"autocmd FileType vim setlocal foldmethod=marker foldlevel=0
let g:grammarous#show_first_error = 1

" FZF {{{
" https://github.com/junegunn/fzf.vim
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Commands keybindings
" Show all files recursively of this folder with bat previewer
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'bat --number --color always {}']}, <bang>0)
nnoremap <leader>f :Files<CR>
" Show all match lines of this buffer
nnoremap <leader>/ :BLines<CR>
" Show all match lines of any buffer
nnoremap <leader>// :Lines<CR>
" Show all match lines of any file
nnoremap <leader>/// :Rg<CR>
" Show all open buffers and their status
nnoremap <Leader>bl :Buffers<CR>
" Show all marks
nnoremap <Leader>m :Marks<CR>
" Show all commits of this repository
nnoremap <localleader>c :Commits<CR>
" Show all commits of this file
nnoremap <localleader>bc :BCommits<CR>
" Show git status command
nnoremap <localleader>gs :GFiles?<CR>
" Show snippets from UltiSnips
nnoremap <localleader>S :Snippets<CR>
" Show Vim commands
nnoremap <localleader>co :Commands<CR>
" Show vim files history
nnoremap <localleader>h :History<CR>
" Show vim commands history
nnoremap <localleader>hc :History:<CR>
" Show vim search history
nnoremap <localleader>hs :History/<CR>
" Show tags of any buffer (ctags -R)
nnoremap <localleader>t :Tags<CR>
" Show tags of this buffer
nnoremap <localleader>bt :BTags<CR>

" Insert mode completion
imap <c-f><c-w> <plug>(fzf-complete-word)
imap <c-f><c-p> <plug>(fzf-complete-path)
imap <c-f><c-f> <plug>(fzf-complete-file-ag)
imap <c-f><c-l> <plug>(fzf-complete-line)

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = "--color --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --follow --smart-case --hidden --no-ignore --no-ignore-parent --glob "!.git/*" --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
\ <bang>0)

cnoreabbrev rg Rg
" }}}

" committia.vim config {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    endif

    " Scroll the diff window from insert mode
    imap <buffer><localleader>j <Plug>(committia-scroll-diff-down-half)
    imap <buffer><localleader>k <Plug>(committia-scroll-diff-up-half)
endfunction
" Always employs single column mode to have word completion
let g:committia_use_singlecolumn = 'always'
" }}}

" github-complete.vim integration {{{
augroup config-github-complete
  autocmd!
  autocmd FileType gitcommit setl omnifunc=github_complete#complete
augroup END
" }}}

" set custom modifier for vim-move
let g:move_key_modifier = 'C'

" Go to the next ALE report
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
nmap <silent> <leader>j <Plug>(ale_next_wrap)
