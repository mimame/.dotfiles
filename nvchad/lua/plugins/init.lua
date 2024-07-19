return {
  -- Easily install luarocks with lazy.nvim
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  -- Configs for lsp
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  -- Small automated session manager
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Only needed if you want to use session lens
    },
    lazy = false,
    config = function()
      require("auto-session").setup {
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        cwd_change_handling = {
          auto_save_enabled = true,
          restore_upcoming_session = true, -- Disabled by default, set to true to enable
          post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
          end,
        },
      }
    end,
  },
  -- Improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- Completely replaces the UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  -- File explorer tree
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        side = "right",
      },
    },
  },
  -- Lightweight yet powerful formatter plugin
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  -- Portable package manager
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  -- Add/change/delete surrounding delimiter pairs with ease
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup()
    end,
  },
  -- general-purpose motion plugin
  {
    "ggandor/leap.nvim",
    config = function()
      -- require('leap').create_default_mappings()
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "gS", "<Plug>(leap-backward)")
      -- vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
    end,
  },
  -- Enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    config = function()
      require("flit").setup()
    end,
  },
  -- search & replace panel
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("spectre").setup()
    end,
  },
  -- Automatically highlighting other uses of the word under the cursor
  {
    "RRethy/vim-illuminate",
    lazy = false,
  },
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- Neovim plugin for Obsidian
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      -- see below for full list of optional dependencies
    },
    config = function()
      -- Use gf for follow Obsidian links
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

      -- Required Default vault
      require("obsidian").setup {
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",
        disable_frontmatter = true,
        -- Optional, for templates (see below).
        templates = {
          subdir = "02.Templates",
          date_format = "%Y.%m-%d",
          time_format = "%H:%M",
          -- A map for custom variables, the key should be the variable and the value a function
          substitutions = {},
        },
        -- Don't use any kind of Zettelkasten ID format
        -- Simply use the title as filename
        note_id_func = function(title)
          return title
        end,
        workspaces = {
          {
            name = "Brain",
            path = "~/Documents/Brain",
          },
        },
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "00.Bullet-Journal-Inbox",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%y.%m.%d.%a",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = nil,
        },
        mappings = {
          -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
          -- ["gf"] = {
          --   action = function()
          --     return require("obsidian").util.gf_passthrough()
          --   end,
          --   opts = { noremap = false, expr = true, buffer = true },
          -- },
        },
        -- Optional, completion.
        completion = {
          -- If using nvim-cmp, otherwise set to false
          nvim_cmp = true,
          -- Trigger completion at 2 chars
          min_chars = 3,
          -- Optional, customize how wiki links are formatted. You can set this to one of:
          --  * "use_alias_only", e.g. '[[Foo Bar]]'
          --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
          --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
          --  * "use_path_only", e.g. '[[foo-bar.md]]'
          -- Or you can set it to a function that takes a table of options and returns a string, like this:
          wiki_link_func = function(opts)
            if opts.id == nil then
              return string.format("[[%s]]", opts.label)
            elseif opts.label ~= opts.id then
              return string.format("[[%s|%s]]", opts.id, opts.label)
            else
              return string.format("[[%s]]", opts.id)
            end
          end,
        },
        -- Optional, configure additional syntax highlighting / extmarks.
        ui = {
          enable = true, -- set to false to disable all additional syntax features
          update_debounce = 200, -- update delay after a text change (in milliseconds)
          -- Define how various check-boxes are displayed
          checkboxes = {
            -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
            -- Replace the above with this if you don't have a patched font:
            -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
            -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

            -- You can also add more custom ones...
          },
          external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          -- Replace the above with this if you don't have a patched font:
          -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          reference_text = { hl_group = "ObsidianRefText" },
          highlight_text = { hl_group = "ObsidianHighlightText" },
          tags = { hl_group = "ObsidianTag" },
          hl_groups = {
            -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
            ObsidianTodo = { bold = true, fg = "#f78c6c" },
            ObsidianDone = { bold = true, fg = "#89ddff" },
            ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
            ObsidianTilde = { bold = true, fg = "#ff5370" },
            ObsidianRefText = { underline = true, fg = "#c792ea" },
            ObsidianExtLinkIcon = { fg = "#c792ea" },
            ObsidianTag = { italic = true, fg = "#89ddff" },
            ObsidianHighlightText = { bg = "#75662e" },
          },
        },
      }

      -- Syntax highlighting
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_folding_disabled = 1
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "markdown", "markdown_inline" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
      }
    end,
  },
}
