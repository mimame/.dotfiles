cmd([[
augroup PackerB
autocmd!
autocmd BufWritePost plugins.lua PackerCompile
augroup end
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- Nvim Treesitter configurations and abstraction layer
  use({
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = ':TSUpdate',
    requires = { { 'windwp/nvim-ts-autotag' }, { 'p00f/nvim-ts-rainbow' }, { 'andymass/vim-matchup' } },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
          enable = true, -- false will disable the whole extension
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        -- Use treesitter to auto close and auto rename html tag
        autotag = {
          enable = true,
        },
        -- About rainbow Rainbow parentheses for neovim using tree-sitter
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
        },
        -- vim match-up: even better % fist_oncoming navigate and highlight matching
        -- words fist_oncoming modern matchit and matchparen replacement
        matchup = {
          enable = true, -- mandatory, false will disable the whole extension
        },
      })
    end,
  })

  -- autopairs for neovim written by lua
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  })

  -- Vim plugin providing operator motions to quickly replace text
  use({ 'svermeulen/vim-subversive' })

  -- Find the enemy and replace them with dark power
  use({
    'windwp/nvim-spectre',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
  })

  -- Git signs written in pure lua
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup()
      opt.signcolumn = 'yes'
    end,
  })

  -- Neovim motions on speed!
  use({
    'phaazon/hop.nvim',
    as = 'hop',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require('hop').setup()
    end,
  })

  -- lsp signature hint when you type
  use({
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  })

  -- Quickstart configurations for the Nvim LSP client
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('./plugins/nvim-lspconfig')
    end,
  })

  -- A completion plugin for neovim coded by Lua
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/vim-vsnip' },
      { 'hrsh7th/vim-vsnip-integ' },
      { 'rafamadriz/friendly-snippets' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'andersevenrud/compe-tmux', branch = 'cmp' },
      { 'kdheepak/cmp-latex-symbols' },
      { 'octaltree/cmp-look' },
      { 'ray-x/cmp-treesitter' },
      { 'f3fora/cmp-nuspell', rocks = { 'lua-nuspell' } },
      { 'f3fora/cmp-spell' },
    },
    config = function()
      require('./plugins/nvim-cmp')
    end,
  })

  -- vscode-like pictograms for neovim lsp completion items
  use({
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init({
        with_text = true,
        preset = 'default',
      })

      local cmp = require('cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              buffer = '[Buffer]',
              nvim_lua = '[nvim-lua]',
              path = '[Path]',
              vsnip = '[Snippet]',
              --  tmux = ''[Tmux']
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  })

  -- Smart and powerful comment plugin for neovim
  -- Supports commentstring, dot repeat, left-right/up-down motions, hooks, and more
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Tmux integration for nvim features pane movement and resizing from within nvim.
  use({
    'aserowy/tmux.nvim',
    config = function()
      -- All copy, and yank synchronization break the use of the system clipboard
      require('tmux').setup({
        -- overwrite default configuration
        -- here, e.g. to enable default bindings
        copy_sync = {
          -- enables copy sync and overwrites all register actions to
          -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
          enable = false,
        },
        -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
        -- clipboard by tmux
        redirect_to_clipboard = false,
        navigation = {
          -- enables default keybindings (C-hjkl) for normal mode
          enable_default_keybindings = true,
        },
        resize = {
          -- enables default keybindings (A-hjkl) for normal mode
          enable_default_keybindings = true,
        },
      })
    end,
  })

  -- A file explorer tree for neovim written in lua
  use({
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        -- open the tree when running this setup function
        open_on_setup = true,
        -- will not open on setup if the filetype is in this list
        -- Never open nvim-tree with git commit messages files
        ignore_ft_on_setup  = { 'git', 'gitcommit', 'COMMIT_EDITMSG', '__committia_diff__' },
        -- closes neovim automatically when the tree is the last **WINDOW** in the view
        auto_close = true,
        -- show lsp diagnostics in the signcolumn
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          }
        },
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab  = true,
        -- update the root directory of the tree to the one of the folder containing
        -- the file if the file is not under the current root directory
        update_focused_file = {
          -- enables the feature
          enable = true,
          -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
          -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable`
          ignore_list  = { 'git', 'gitcommit', 'COMMIT_EDITMSG', '__committia_diff__' },
        },
        view = {
          -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
          side = 'right',
          -- if true the tree will resize itself after opening a file
          auto_resize = true,
        }
      })
      -- show relative numbers
      require('nvim-tree.view').View.winopts.relativenumber = true
      -- Always open nvim-tree automatically at startup
      -- Force nvim-tree to find the file at startup
      cmd("NvimTreeFindFile")
      cmd("normal! zz<CR>")
      cmd("wincmd p")
      require("nvim-tree.events").on_nvim_tree_ready(function()
        if vim.bo.filetype == 'gitcommit' or vim.bo.filetype == 'git' or vim.fn.expand('#')  == "__committia_diff__" or vim.fn.expand('#') == 'COMMIT_EDITMSG' then
          cmd("NvimTreeToggle")
          cmd("NvimTreeClose")
        else
          cmd("NvimTreeFindFile")
          cmd("normal! zz<CR>")
          cmd("wincmd p")
        end
      end)
    end,
  })

  -- vim dashboard
  use({
    'glepnir/dashboard-nvim',
    config = function()
      g.dashboard_default_executive = 'telescope'
      g.dashboard_custom_shortcut = {
        last_session = '<leader> d l',
        find_history = '<leader> d h',
        find_file = '<leader> d f',
        new_file = '<leader> d n',
        change_colorscheme = '<leader> d c',
        find_word = '<leader> d w',
        book_marks = '<leader> d b',
      }
      cmd([[
      augroup dasboard_no_indent_lines
      au!
      au FileType dashboard IndentBlanklineDisable
      augroup END
      ]])
    end,
  })

  -- The fastest Neovim colorizer
  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      -- Attaches to every FileType mode
      require('colorizer').setup()
    end,
  })

  -- Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
  use({
    'folke/which-key.nvim',
    config = function()
      require('./plugins/which-key')
    end,
  })

  --  Indent guides for Neovim
  -- :h buftype
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '┊',
        buftype_exclude = { 'terminal' },
        fileTypeExclude = { 'dashboard' },
        indent_blankline_use_treesitter = true,
        indent_blankline_show_current_context = true,
      })
    end,
  })

  -- Find, Filter, Preview, Pick. All lua, all the time.
  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          kayout_strategy = 'horizontal',
          layout_config = {
            horizontal = { preview_cutoff = 500 },
          },
          previewer = true,
          file_ignore_patterns = { 'node_modules/.*', '.git/.*', '.snakemake/.*', './conda/.*' },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },
      })
    end,
  })

  -- A snazzy bufferline for Neovim
  use({
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        options = {
          numbers = function(opts)
            return string.format('%s', opts.ordinal)
          end,
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          left_mouse_command = 'buffer %d',
          middle_mouse_command = nil,
          -- NOTE: this plugin is designed with this icon in mind,
          -- and so changing this is NOT recommended, this is intended
          -- as an escape hatch for people who cannot bear it for whatever reason
          indicator_icon = '▎',
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          --- name_formatter can be used to change the buffer's label in the bufferline.
          --- Please note some names can/will break the
          --- bufferline so use this at your discretion knowing that it has
          --- some limitations that will *NOT* be fixed.
          name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match('%.md') then
              return vim.fn.fnamemodify(buf.name, ':t:r')
            end
          end,
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = ' '
            for e, n in pairs(diagnostics_dict) do
              local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or '')
              s = s .. n .. sym
            end
            return s
          end,
          offsets = { { filetype = 'NvimTree', text = 'File Explorer', text_align = 'left' } },
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          -- can also be a table containing 2 custom separators
          -- [focused and unfocused]. eg: { '|', '|' }
          separator_style = 'thin',
          -- enforce_regular_tabs = false | true,
          always_show_bufferline = true,
          sort_by = 'id',
        },
      })
    end,
  })

  -- A neovim lua plugin to help easily manage multiple terminal windows
  use({
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<c-t>]],
        -- insert_mappings = true, -- whether or not the open mapping applies in insert mode
        start_in_insert = true,
        hide_numbers = true, -- hide the number column in toggleterm buffers
        direction = 'tab',
        close_on_exit = true, -- close the terminal window when the process exits
      })
      function _G.set_terminal_keymaps()
        local opts = { noremap = true }
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      --vim.cmd('autocmd! TermOpen * startinsert')
      --vim.cmd('autocmd! BufEnter term://* startinsert')
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  })

  -- A minimal, stylish and customizable statusline for Neovim written in Lua
  use({
    'famiu/feline.nvim',
    config = function()
      require('./plugins/feline-nvim')
    end,
  })

  -- A NeoVim plugin for saving your work before the world collapses or you type :qa!
  use({
    'Pocco81/AutoSave.nvim',
    config = function()
      require("autosave").setup()
    end
  })

  -- More useful word motions for Vim
  use({ 'chaoren/vim-wordmotion' })

  use({
    'machakann/vim-highlightedyank',
    config = function()
      g.highlightedyank_highlight_duration = 200
      cmd('highlight HighlightedyankRegion cterm=reverse gui=reverse')
    end,
  })

  -- Syntax for i3 config
  use({ 'mboughaba/i3config.vim' })

  -- Syntax for snakemake
  use({
    'snakemake/snakemake',
    rtp = 'misc/vim',
    config = function()
      cmd('au BufNewFile,BufRead Snakefile,*.smk set filetype=snakemake')
    end,
  })

  -- EditorConfig plugin for Vim
  use({ 'editorconfig/editorconfig-vim' })

  -- Selectively illuminating other uses of the current word under the cursor
  use({ 'RRethy/vim-illuminate' })

  -- A Vim plugin for more pleasant editing on commit messages
  use({ 'rhysd/committia.vim' })

  -- Open file with line and column associated (vim/:e[edit]/gF path/to/file.ext:12:3)
  use({ 'wsdjeg/vim-fetch' })

  -- Highlights trailing whitespace in red and provides :FixWhitespace to fix it
  use({ 'bronson/vim-trailing-whitespace' })

  -- A cheatsheet plugin for neovim with bundled cheatsheets for the editor,
  -- multiple vim plugins, nerd-fonts, regex, etc. with a Telescope fuzzy finder interface
  use({
    'sudormrfbin/cheatsheet.nvim',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
  })

  -- Set of operators and textobjects to search/select/edit sandwiched texts
  use({ 'machakann/vim-sandwich' })

  -- Smooth scrolling neovim plugin written in lua
  use({
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  })

  -- markdown preview plugin for (neo)vim
  use({
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
  })

  -- A small automated session manager for Neovim
  use({ 'rmagatti/auto-session' })

  -- Vim plugin that allows use of vifm as a file picker
  use({ 'vifm/vifm.vim' })

  -- High Contrast & Vivid Color Scheme based on Monokai Pro
  use({ 'sainnhe/sonokai' })
end)
