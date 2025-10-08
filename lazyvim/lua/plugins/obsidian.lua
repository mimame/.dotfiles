return {
  -- Neovim plugin for Obsidian
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
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
      require("obsidian").setup({
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",
        disable_frontmatter = true,
        -- Optional, for templates (see below).
        templates = {
          subdir = "3.Templates",
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
          folder = "1.Journal",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%y.%m.%d.%a",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = nil,
        },
        -- Optional, completion.
        completion = {
          -- If using nvim-cmp, otherwise set to false
          nvim_cmp = false,
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
        },
      })

      -- Syntax highlighting
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },
}
