-- Set encoding before scriptencoding
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- Leader key
g.mapleader = ' '
g.maplocalleader = ';'

-- The screen will not be redrawn while executing macros, registers and other commands
opt.lazyredraw = true

-- Lowering synmaxcol improves performance in files with long lines
opt.synmaxcol = 500

-- Use system clipboard by default
opt.clipboard = opt.clipboard ^ { 'unnamedplus', 'unnamed' }

-- Filetype detection with plugins and indentation
cmd('filetype plugin indent on')

-- Syntax highlighting
opt.syntax = 'on'

-- Don't use swap files
opt.swapfile = false

--  Change from a buffer without written changes
opt.hidden = true

-- Mapping delays
opt.timeoutlen = 1000

-- Lower timeoutlen inside insert mode to reduce the latency caused waiting insert mappings
api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  command = 'set timeoutlen=200',
  desc = 'Lower timeoutlen inside insert mode to reduce the latency caused waiting insert mappings',
})
api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set timeoutlen=1000',
  desc = 'Increase timeoutlen after leaving insert mode modified to decrease latency caused waiting insert mappings',
})

-- No timeout when typing leader key
opt.ttimeout = true

-- Key code delays (perhaps 0?)
opt.ttimeoutlen = 0
-- Enable numbers
opt.number = true

-- Enable relativenumbers
opt.relativenumber = true

-- Minimal number of screen lines to keep above and below the cursor
-- This will make some context visible around where you are working
opt.scrolloff = 1

-- sidescrollof to the right of the cursor if 'nowrap' is set.
-- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
opt.sidescrolloff = 5

-- Change the way text is displayed
-- lastline: When included, as much as possible of the last line in a window will be displayed
opt.display = opt.display + 'lastline'

-- Enable spell en_gb by default
opt.spell = true
opt.spelllang = 'en_us'

-- Autocomplete with dictionary words
opt.complete = opt.complete + 'kspell'

-- Highlight the searched word
opt.hlsearch = true

-- Search word while typing
opt.incsearch = true

-- All matches in a line are substituted instead of one
opt.gdefault = true

-- Ignore case in searches
opt.ignorecase = true

-- Case sensitive only with an uppercase letter
opt.smartcase = true

-- Tabs only for indent, for alignments tabs insert spaces
opt.smarttab = true

-- Tabs became spaces
opt.expandtab = true

-- -- 2 spaces for tab
opt.tabstop = 2

--2 spaces for indentation
opt.shiftwidth = 2

-- Feel spaces as real tabs
opt.softtabstop = 2

-- Automatically inserts one extra level of indentation in some cases
opt.smartindent = true
--
-- Copy the indentation of the previous line
opt.autoindent = true

-- Indent wrapped lines
opt.breakindent = true

-- Show spaces, tabs and breaklines with characters using :set list
opt.listchars = {
  eol = '⏎',
  tab = '⇥\\',
  trail = '␣',
  nbsp = '⎵',
  space = '·',
  precedes = '«',
  extends = '»',
}
opt.list = true

-- Show this in wrapped lines
opt.showbreak = '↳ '

-- Wrap lines
opt.wrap = true

-- showbreak in linenumbers column (no working perhaps by numbers plugin)
opt.cpoptions = opt.cpoptions + 'n'

-- This turns off physical line wrapping (ie: automatic insertion of newlines)
opt.textwidth = 0
opt.wrapmargin = 0

-- Remove automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode behavior
-- http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
-- https://vi.stackexchange.com/a/1985
opt.formatoptions = opt.formatoptions - 'c'
opt.formatoptions = opt.formatoptions - 'r'
opt.formatoptions = opt.formatoptions - 'o'
opt.formatoptions = opt.formatoptions + 'j' -- Delete comment character when joining commented lines

-- Force to set formatoptions for each type of files
api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  command = "set fo-=c fo-=r fo-=o fo+=j",
  desc = 'Force to set formatoptions for each type of files',
})

-- Wrap lines at breakat
opt.linebreak = true

-- Highlight the current line
opt.cursorline = true

-- Enable read vim options in any file
opt.modeline = true

-- Number of commands in :history
opt.history = 10000

-- Max opened tabs
opt.tabpagemax = 50

-- Enable completion
opt.omnifunc = 'syntaxcomplete#Complete'

-- Show popup also with only one match
-- Force the user to select one match from the menu
opt.completeopt = 'menu,menuone,noselect'

-- Delete over line breaks, automatically-inserted indentation, place where insert mode started
opt.backspace = 'indent,eol,start'

-- Tags file instead of scanning includes
opt.complete = opt.complete - 'i'

-- Increase numbers like 0X as decimals with visual mode g+ctrl-a
opt.nrformats = opt.nrformats - 'octal'

-- Increase alpha characters with visual mode g+ctrl-a
opt.nrformats = opt.nrformats + 'alpha'

-- Status line
opt.laststatus = 2

-- In the right side of the status line: line number, column number, virtual column number, relative position
opt.ruler = true

-- Break plugins: Search recursive with :find and tab-completion for all file related task
opt.path = opt.path + '**'

-- Complete commands/folders
-- Folder navigation https://xaizek.github.io/2012-10-08/vim-wild-menu/
opt.wildmenu = true

-- Complete to the longest common string and invoke wildmenu
opt.wildmode = 'longest:full,full'

-- Complete ingnoring case sensitive
opt.wildignorecase = true

-- Enable mouse in all modes
opt.mouse = 'a'

-- Reload file after external command like !ls
opt.autoread = true

-- Write file when the focus is lost
cmd('au FocusLost,WinLeave * :silent! w')

-- Write the contents of the file, if it has been modified
opt.autowriteall = true

-- Show the current command when typing it at status line
opt.showcmd = true

-- Recommended sessionoptions config
opt.sessionoptions = 'blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal'
-- Never remember global options for sessions
opt.sessionoptions = opt.sessionoptions - { options }

-- Never remember global options for views
opt.viewoptions = opt.viewoptions - { options }

-- Never hide symbols
opt.conceallevel = 0
opt.concealcursor = ''

-- Keep undo history across sessions by storing it in a file
opt.undofile = true
fn.system('mkdir -p /tmp/.nvim_undo')
opt.undodir = '/tmp/.nvim_undo'

-- Improve default grepprg
opt.grepprg = [[rg --vimgrep --no-heading]]
opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'

-- Search upwards for tags file and prevent duplicate entry in 'tags'
opt.tags = opt.tags - './tags'
opt.tags = opt.tags - './tags;'
opt.tags = opt.tags ^ './tags;'

-- Always start with insert mode in new files
api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  command = 'startinsert',
  desc = 'Always start with insert mode in new files',
})

-- Shows the effects of a command incrementally like :substitute
opt.inccommand = 'nosplit'

-- Gutter symbols update immediately (very weird glitches in vim)
-- https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
opt.updatetime = 100

-- 256 colors in terminal
opt.termguicolors = true

-- Folds opened by default
opt.foldenable = true
opt.foldlevel = 99
-- Fold based on indent
opt.foldmethod = 'indent'
opt.foldcolumn = '1'

-- Some servers have issues with backup files, see #649.
opt.backup = false
opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 300

-- Merge signcolumn and number column into one
opt.signcolumn = 'auto:2-8'

-- Don't pass messages to |ins-completion-menu|.
opt.shortmess = opt.shortmess + 'c'

-- Write file and create the folder if not exists
-- https://vi.stackexchange.com/a/679
local mkdir_group = api.nvim_create_augroup("Mkdir", { clear = true })
api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = 'call mkdir(expand("<afile>:p:h"), "p")',
  group = mkdir_group,
  desc = 'Write file and create the folder if not exists',
})

-- Highlight the yank with orange
cmd([[
highlight HighlightedyankRegion guibg=#FD971F guifg=#000000 gui=bold ctermbg=208 ctermfg=0 cterm=bold
]])

-- Always open git commit files in insert mode
api.nvim_create_autocmd('VimEnter', {
  pattern = 'gitcommit',
  command = "exec 'au VimEnter * startinsert'",
  desc = 'Always start with insert mode in new files',
})
api.nvim_create_autocmd('BufRead', {
  pattern = 'COMMIT_EDITMSG',
  command = "exec 'norm gg' | startinsert!",
  desc = 'Always start with insert mode in new files',
})
