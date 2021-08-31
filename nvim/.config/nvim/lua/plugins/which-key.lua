require('which-key').setup({
  plugins = {
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
  },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
})

local wk = require('which-key')

wk.register({
  t = {
    name = 'Telescope', -- optional group name
    b = { "<cmd>lua require('telescope.builtin').file_browser({depth=5})<cr>", 'File browser' },
    c = { '<cmd>Telescope commands<cr>', 'Available commands' },
    f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", 'Find file' },
    g = { '<cmd>Telescope live_grep<cr>', 'Grep' },
    h = { '<cmd>Telescope oldfiles<cr>', 'History' },
    q = { '<cmd>Telescope quickfix<cr>', 'Show quickfix window' },
    t = { '<cmd>Telescope tags<cr>', 'Tags' },
    w = { '<cmd>Telescope grep_string<cr>', 'Grep this word' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  b = {
    -- https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
    name = 'buffer',
    n = { '<cmd>enew<cr>', 'Create a new empty buffer' },
    b = { '<cmd>Telescope buffers<cr>', 'Show all buffers' },
    d = { '<cmd>BufferClose<cr>', 'Delete the current buffer' },
    l = { '<cmd>BufferNext<cr>', 'Go to the next buffer' },
    h = { '<cmd>BufferPrevious<cr>', 'Go to the previous buffer' },
    a = { '<cmd>exec "normal! ggVG"<cr>', 'Select the whole buffer' },
    v = { '<cmd>exec "normal! HVL"<cr>', 'Select only the shown part of the buffer' },
    ["1"] = { '<cmd>BufferGoto 1<cr>', 'Go to buffer 1' },
    ["2"] = { '<cmd>BufferGoto 2<cr>', 'Go to buffer 2' },
    ["3"] = { '<cmd>BufferGoto 3<cr>', 'Go to buffer 3' },
    ["4"] = { '<cmd>BufferGoto 4<cr>', 'Go to buffer 4' },
    ["5"] = { '<cmd>BufferGoto 5<cr>', 'Go to buffer 5' },
    ["6"] = { '<cmd>BufferGoto 6<cr>', 'Go to buffer 6' },
    ["7"] = { '<cmd>BufferGoto 7<cr>', 'Go to buffer 7' },
    ["8"] = { '<cmd>BufferGoto 8<cr>', 'Go to buffer 8' },
    ["9"] = { '<cmd>BufferGoto 9<cr>', 'Go to buffer 9' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  g = {
    name = 'Git',
    f = { '<cmd>Telescope git_files<CR>', 'Git Files' },
    c = { '<cmd>Telescope git_commits<CR>', 'Git Commits' },
    b = { '<cmd>Telescope git_branches<cr>', 'Git Branches' },
    --s = { '<cmd>Telescope git_status<cr>', 'Git status' },
    n = { '<cmd>lua require"gitsigns.actions".next_hunk()<cr>', 'Go to the next hunk' },
    p = { '<cmd>lua require"gitsigns.actions".prev_hunk()<cr>', 'Go to the previous hunk' },
    s = { '<cmd>lua require"gitsigns.actions".stage_hunk()<cr>', 'Stage hunk' },
    u = { '<cmd>lua require"gitsigns.actions".undo_stage_hunk()<cr>', 'Undo stage hunk' },
    r = { '<cmd>lua require"gitsigns.actions".reset_hunk()<cr>', 'Undo stage hunk' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  d = {
    name = 'Dashboard',
    b = { '<cmd>DashboardJumpMark<cr>', 'Bookmarks' },
    c = { '<cmd>Telescope colorscheme<cr>', 'Color Scheme' },
    f = { '<cmd>DashboardFindFile<cr>', 'Find file' },
    h = { '<cmd>DashboardFindHistory<CR>', 'History' },
    n = { '<cmd>DashboardNewFile<cr>', 'Create new file' },
    w = { '<cmd>DashboardFindWord<cr>', 'Find word' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  v = {
    name = 'nvimrc',
    o = { "<cmd>execute 'e '. resolve(expand($MYVIMRC))<CR>", 'Open nvimrc' },
    r = { '<cmd>source $MYVIMRC<CR>', 'Reload nvimrc' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  j = {
    name = 'Jump',
    w = { '<cmd>HopWord<CR>', 'Jump to word' },
    l = { '<cmd>HopLine<CR>', 'Jump to line' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  l = {
    name = 'LSP',
    p = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go to previous diagnostic' },
    n = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go to next diagnostic' },
    l = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show line' },
    s = { '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set loc list' },
    f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Formatting' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  s = {
    name = 'Symbol',
    r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename symbol' },
    d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Symbol definition' },
    f = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Symbol declaration' },
    h = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover Symbol' },
    i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Symbol implementation' },
    s = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Symbol signature' },
    t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Symbol type' },
    a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Symbol action' },
    e = { '<cmd>lua vim.lsp.buf.references()<CR>', 'Symbol references' },
  },
}, {
  prefix = '<localleader>',
})

wk.register({
  w = {
    name = 'Workspace',
    a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder' },
    r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder' },
    l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List workspace folders' }
  },
}, {
  prefix = '<localleader>',
})

wk.register({
  w = {
    name = 'Window',
    s = { '<C-w>s<CR>', 'Horizontal Window split' },
    v = { '<C-w>v<CR>', 'Vertical Window split' },
    o = { '<C-w>o<CR>', 'Only window' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  f = {
    name = 'File',
    q = { '<cmd>q<CR>', 'Close file' },
    w = { '<cmd>w<CR>', 'Write file' },
    e = { '<cmd>e<CR>', 'Edit file' },
    s = { "<cmd>'<,'>!sort --human-numeric-sort<CR>", 'Sort file region' },
  },
}, {
  prefix = '<leader>',
})

wk.register({
  s = {
    name = 'Search and Replace',
    s = { '<cmd>lua require("spectre").open()<CR>', 'Open Spectre' },
    S = { '<cmd>lua require("spectre").open_visual()<CR>', 'Open visual Spectre' },
    w = { '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', 'Search current word' },
    p = { '<cmd>lua require("spectre").open_file_search()<CR>', 'Search in current file' },
  },
}, {
  prefix = '<leader>',
})
