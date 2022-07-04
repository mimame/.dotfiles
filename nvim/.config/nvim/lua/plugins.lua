cmd([[
augroup PackerB
autocmd!
autocmd BufWritePost plugins.lua PackerCompile
augroup end
]])

api.nvim_create_user_command('PackerSnapshotSync', function(args)
  local packer = require('packer')
  local t = os.date('%d-%m-%y_%H-%M-%S')
  local filepath = '/tmp/' .. 'packer_' .. t .. '.txt'
  cmd('PackerSnapshot ' .. filepath)
  cmd('PackerSync')
end, {
  desc = 'PackerSnapshot + PackerSync',
})

return require('packer').startup(function()
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- Nvim Treesitter configurations and abstraction layer
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = { { 'windwp/nvim-ts-autotag' }, { 'p00f/nvim-ts-rainbow' }, { 'andymass/vim-matchup' } },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all', -- one of "all", or a list of languages
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

  -- Highlight arguments' definitions and usages, using Treesitter
  use({
    'm-demare/hlargs.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('hlargs').setup()
    end,
  })

  -- Show code context
  use({
    'romgrk/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
  })

  -- A better annotation generator. Supports multiple languages and annotation conventions.
  use({
    'danymat/neogen',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('neogen').setup({
        enabled = true,
        snippet_engine = 'luasnip',
      })
    end,
  })

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use({
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('null-ls').setup({
        sources = {
          -- https://github.com/hrsh7th/nvim-cmp/discussions/794
          -- Remove weird completion conflict with nvim-cmp
          -- require('null-ls').builtins.completion.spell,
          require('null-ls').builtins.diagnostics.zsh,
          require('null-ls').builtins.formatting.stylua,
          require('null-ls').builtins.formatting.nimpretty,
          require('null-ls').builtins.formatting.crystal_format,
          require('null-ls').builtins.formatting.shfmt,
          require('null-ls').builtins.code_actions.shellcheck,
          require('null-ls').builtins.formatting.zigfmt,
          require('null-ls').builtins.formatting.fish_indent,
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
      opt.signcolumn = 'auto:2-8'
    end,
  })

  -- magit for neovim
  use({
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup({
        disable_commit_confirmation = true,
        disable_insert_on_commit = false,
        -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
        -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
        -- Change the default way of opening neogit
        kind = 'tab',
        commit_popup = {
          kind = 'tab',
        },
        auto_refresh = true,
        sections = {
          untracked = {
            folded = true,
          },
        },
      })
    end,
  })

  -- Next-generation motion plugin with incremental input processing,
  -- allowing for unparalleled speed with near-zero cognitive effort
  use({
    'ggandor/lightspeed.nvim',
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


  --  Snippet Engine for Neovim written in Lua.
  use({
    'L3MON4D3/LuaSnip',
    requires = { { 'honza/vim-snippets' }, { 'rafamadriz/friendly-snippets' } },
    config = function()
      require('luasnip.loaders.from_snipmate').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  })

  -- A completion plugin for neovim coded by Lua
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'andersevenrud/cmp-tmux' },
      { 'kdheepak/cmp-latex-symbols' },
      { 'octaltree/cmp-look' },
      { 'ray-x/cmp-treesitter' },
      -- { 'f3fora/cmp-nuspell', rocks = { 'lua-nuspell' } },
      -- { 'uga-rosa/cmp-dictionary' },
      -- { 'f3fora/cmp-spell' },
      { 'hrsh7th/cmp-cmdline' },
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
        mode = 'symbol_text',
      })

      local cmp = require('cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            with_text = true, -- do not show text alongside icons
            maxwidth = 120, -- prevent the popup from showing more than provided characters (e.g 120 will not show more than 120 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
              vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snippet]',
                treesitter = '[Treesitter]',
                buffer = '[Buffer]',
                path = '[Path]',
                nvim_lua = '[nvim-lua]',
                tmux = '[Tmux]',
                look = '[Look]',
                latex_symbols = '[Latex]',
                -- dictionary = '[dictionary]',
                -- nuspell = '[Nuspell]',
                -- spell = '[Spell]',
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
      })
    end,
  })

  -- Smart and powerful comment plugin for neovim
  -- Supports commentstring, dot repeat, left-right/up-down motions, hooks, and more
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })

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
        -- Don't disable and hijack netrw by default
        -- https://github.com/neovim/neovim/issues/13675#issuecomment-885666975
        -- disables netrw completely
        disable_netrw = false,
        -- hijack netrw window on startup
        hijack_netrw = true,
        -- open the tree when running this setup function
        open_on_setup = false,
        --  will automatically open the tree when running setup if startup buffer is a file.
        -- File window will be focused.
        open_on_setup_file = false,
        -- show lsp diagnostics in the signcolumn
        diagnostics = {
          enable = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab = true,
        -- update the root directory of the tree to the one of the folder containing
        -- the file if the file is not under the current root directory
        update_focused_file = {
          -- enables the feature
          enable = true,
        },
        view = {
          -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
          side = 'right',
        },
        actions = {
          open_file = {
            -- if true the tree will resize itself after opening a file
            resize_window = true,
          },
        },
      })
      -- show relative numbers
      require('nvim-tree.view').View.winopts.relativenumber = true
    end,
  })

  -- Not UFO in the sky, but an ultra fold in Neovim.
  use({
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      -- global handler
      require('ufo').setup({
        fold_virt_text_handler = handler,
      })
    end,
  })

  -- a lua powered greeter like vim-startify / dashboard-nvim
  use({
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }
      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', '  Recently opened files', '<cmd>Telescope oldfiles<cr>'),
        dashboard.button('f', '  Find file', '<cmd>Telescope find_files<cr>'),
        dashboard.button('s', '  Find word', '<cmd>Telescope live_grep<cr>'),
        dashboard.button('m', '  Jump to marks', '<cmd>Telescope marks<cr>'),
        dashboard.button('S', '  Find session', '<cmd>Telescope session-lens search_session<cr>'),
        -- dashboard.button('f', '  Frequency/MRU', ),
        dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
      }
      dashboard.config.opts.noautocmd = true
      vim.cmd([[autocmd User AlphaReady echo 'ready']])
      alpha.setup(dashboard.config)
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

  -- A legend for your keymaps and commands
  use({
    'mrjones2014/legendary.nvim',
  })

  -- Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
  use({
    'folke/which-key.nvim',
    config = function()
      require('./plugins/which-key')
    end,
  })

  -- Improve the default vim.ui interfaces
  use({
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        input = {
          -- Window transparency (0-100)
          winblend = 0,
        },
      })
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
      -- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-993956937
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- Workaround for https://github.com/nvim-telescope/telescope.nvim/issues/1048
      local multiopen = function(prompt_bufnr, open_cmd)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local num_selections = #picker:get_multi_selection()
        if not num_selections or num_selections <= 1 then
          actions.add_selection(prompt_bufnr)
        end
        actions.send_selected_to_qflist(prompt_bufnr)

        local results = vim.fn.getqflist()

        for _, result in ipairs(results) do
          local current_file = vim.fn.bufname()
          local next_file = vim.fn.bufname(result.bufnr)

          if current_file == '' then
            vim.api.nvim_command('edit' .. ' ' .. next_file)
          else
            vim.api.nvim_command(open_cmd .. ' ' .. next_file)
          end
        end

        vim.api.nvim_command('cd .')
      end

      local function multi_selection_open_vsplit(prompt_bufnr)
        multiopen(prompt_bufnr, 'vsplit')
      end

      local function multi_selection_open_split(prompt_bufnr)
        multiopen(prompt_bufnr, 'split')
      end

      local function multi_selection_open_tab(prompt_bufnr)
        multiopen(prompt_bufnr, 'tabedit')
      end

      require('telescope').setup({
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
            '--hidden',
            '--ignore-file="~/.config/fd/ignore"',
          },
          layout_strategy = 'horizontal',
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top" },
          },
          wrap_results = true,
          previewer = true,
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<Tab>'] = actions.move_selection_next,
              ['<S-Tab>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.toggle_selection + actions.move_selection_better,
              ['<C-k>'] = actions.toggle_selection + actions.move_selection_worse,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              'fd',
              '--type',
              'f',
              '--strip-cwd-prefix',
              '--hidden',
            },
            mappings = {
              i = {
                ['<C-V>'] = multi_selection_open_vsplit,
                ['<C-X>'] = multi_selection_open_split,
                ['<CR>'] = multi_selection_open_tab,
              },
            },
          },
        },
      })
    end,
  })

  -- A pretty diagnostics, references, telescope results, quickfix
  -- and location list to help you solve all the trouble your code is causing
  use({
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup({})
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

  -- Viewer & Finder for LSP symbols and tags
  use({ 'liuchengxu/vista.vim' })

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
        api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      --vim.cmd('autocmd! TermOpen * startinsert')
      --vim.cmd('autocmd! BufEnter term://* startinsert')
      api.nvim_create_autocmd('TermOpen', {
        pattern = '*',
        command = 'term://* lua set_terminal_keymaps()',
        desc = 'Always start with insert mode in new files',
      })
    end,
  })

  -- Send code to command line interpreter
  use({
    'jalvesaq/vimcmdline',
    config = function()
      cmd([[ let cmdline_external_term_cmd = 'alacritty --title "Julia: ' . expand("%:t") . '" --command %s &' ]])
    end,
  })

  -- A minimal, stylish and customizable statusline for Neovim written in Lua
  use({
    'feline-nvim/feline.nvim',
    config = function()
      require('./plugins/feline-nvim')
    end,
  })

  -- A NeoVim plugin for saving your work before the world collapses or you type :qa!
  use({
    'Pocco81/AutoSave.nvim',
    config = function()
      require('autosave').setup()
    end,
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

  -- Just Syntax
  use({ 'NoahTheDuke/vim-just' })

  --  Asciidoctor plugin
  use({ 'habamax/vim-asciidoctor' })

  -- Syntax for snakemake
  use({
    'snakemake/snakemake',
    rtp = 'misc/vim',
    config = function()
      cmd('au BufNewFile,BufRead Snakefile,*.smk set filetype=snakemake')
    end,
  })

  -- A (Neo)vim plugin for formatting code
  use({ 'sbdchd/neoformat' })

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
  use({
    'machakann/vim-sandwich',
    config = function()
      -- `ys`, `yss`, `yS`, `ds`, `cs` in normal mode and `S` in visual mode
      -- are available. Not in vim-surround but `dss` and `css` are also
      -- available, these are similar as `ds` and `cs` but determine
      -- deleted/replaced texts automatically
      cmd('runtime macros/sandwich/keymap/surround.vim')
    end,
  })

  -- Smooth scrolling neovim plugin written in lua
  use({
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  })

  -- Stabilize window open/close events
  use({
    'luukvbaal/stabilize.nvim',
    config = function()
      require('stabilize').setup()
    end,
  })

  -- A markdown preview directly in your neovim
  use({
    'ellisonleao/glow.nvim',
    config = function()
      vim.g.glow_border = 'rounded'
      vim.g.glow_use_pager = true
    end,
  })
  -- markdown preview plugin for (neo)vim
  use({
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
  })

  -- Single tabpage interface for easily cycling
  -- diffs for all modified files for any git rev
  -- use({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })

  -- A small automated session manager for Neovim
  use({
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup({
        -- pre_save_cmds = {"tabdo NvimTreeClose", "autocmd! FileType alpha Alpha"},
        auto_save_enabled = true,
        auto_restore_enabled = false,
        -- post_restore_cmds = {"tabdo NvimTreeRefresh"}
      })
    end,
  })

  -- A session-switcher extension for rmagatti/auto-session
  -- using Telescope.nvim
  use({
    'rmagatti/session-lens',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'rmagatti/auto-session' },
      config = function()
        require('session-lens').setup({ --[[your custom config--]]
        })
      end,
    },
  })

  -- Highlight, list and search todo comments in your projects
  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup({})
    end,
  })

  -- Escape from insert mode without delay when typing
  use({
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup()
    end,
  })

  -- Plugin for Vim that makes it easier to record / play / edit macros
  use({ 'svermeulen/vim-macrobatics' })

  -- A better user experience for viewing and interacting with Vim marks
  use({
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        sign_priority = 10,
      })
    end,
  })

  -- Nim plugin
  use({ 'alaviss/nim.nvim' })

  -- VIM syntax plugin for Tridactyl configuration files
  use({ 'tridactyl/vim-tridactyl' })

  -- Vim plugin that allows use of vifm as a file picker
  use({ 'vifm/vifm.vim' })

  -- Displays startup time
  use({ 'tweekmonster/startuptime.vim' })

  -- High Contrast & Vivid Color Scheme based on Monokai Pro
  use({ 'sainnhe/sonokai' })

  -- Vim plugin for profiling Vim's startup time.
  use({ 'dstein64/vim-startuptime' })
end)
