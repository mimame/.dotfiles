return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

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
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  -- general-purpose motion plugin
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
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
  {
    "RRethy/vim-illuminate",
    lazy = false,
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
