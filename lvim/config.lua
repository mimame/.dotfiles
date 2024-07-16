-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.spell = true
vim.opt.wrap = true
-- Concealed text is hidden unless a custom replacement character defined
vim.wo.conceallevel = 2
-- set cursor of insert mode as vertical line
vim.opt.guicursor = "i:ver1"
-- Set sh as default shell
-- https://www.lunarvim.org/docs/troubleshooting#are-you-using-fish
vim.opt.shell = "/bin/sh"

-- general
lvim.log.level = "info"
lvim.format_on_save.enable = false
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["aa"] = "<Esc>"
lvim.keys.insert_mode[";;"] = "<Enter>"
local function show_colon_and_enter_command_mode()
	-- Print a colon to simulate entering command mode
	vim.api.nvim_echo({ { ":", "Normal" } }, false, {})
	-- Enter command mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":", true, false, true), "n", true)
end
-- Map semicolon to the custom function in normal mode
lvim.keys.normal_mode[";"] = show_colon_and_enter_command_mode
-- Trouble.nvim
lvim.builtin.which_key.mappings["t"] = {
	name = "Diagnostics",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.autopairs.active = true
-- Manual mode doesn't automatically change your root directory, so you have
-- the option to manually do so using `:ProjectRoot`
-- lvim.builtin.project.active = false
lvim.builtin.project.manual_mode = true
-- Show hidden files in telescope
lvim.builtin.project.show_hidden = true

-- lvim.builtin.lualine.style = "lvim"
lvim.builtin.lualine.options.section_separators = { left = "", right = "" }
lvim.builtin.lualine.options.component_separators = { left = "|", right = "|" }
local components = require("lvim.core.lualine.components")
components.filename.path = 4
components.filename.color = {
	gui = "bold",
}
components.filetype.separator = ""
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	components.diagnostics,
	components.location,
	components.progress,
	components.filetype,
	components.filename,
}
lvim.builtin.lualine.sections.lualine_x = {
	components.lsp,
	components.spaces,
	components.encoding,
}
lvim.builtin.lualine.sections.lualine_y = {}
lvim.builtin.lualine.sections.lualine_z = {
	"fileformat",
}

lvim.builtin.lualine.inactive_sections.lualine_c = {
	components.diff,
	components.lsp,
	components.diagnostics,
	components.spaces,
	components.filename,
}
lvim.builtin.lualine.inactive_sections.lualine_x = {}

-- Enable DAP support by default
lvim.builtin.dap.active = true

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.highlight.enable = true

lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }
-- local code_actions = require "lvim.lsp.null-ls.code_actions"
-- code_actions.setup {
--   {
--     exe = "eslint",
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
-- lvim.plugins = {
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }
lvim.plugins = {
	-- Easily install luarocks with lazy.nvim
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
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
			require("noice").setup({
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
			})
		end,
	},
	-- Lightweight yet powerful formatter plugin
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	-- Navigate your code with search labels, enhanced character motions and Treesitter integration
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"echasnovski/mini.align",
		version = "*",
		config = function()
			require("mini.align").setup()
		end,
	},
	-- search & replace panel
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("spectre").setup()
		end,
	},
	-- better quickfix window
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	-- navigate and highlight matching words
	-- query.lua:259: query: invalid node type at position 6 for language lua
	-- {
	--   "andymass/vim-matchup",
	--   event = "CursorMoved",
	--   config = function()
	--     vim.g.matchup_matchparen_offscreen = { method = "popup" }
	--   end,
	-- },
	-- git diff in a single tabpage
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	-- autoclose and autorename html tag
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	-- commentstring option based on the cursor location
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	-- rainbow parentheses
	{
		url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
			lvim.builtin.treesitter.rainbow.enable = true
		end,
	},
	-- FIXME: enable it again when it works again
	-- Error detected while processing CursorMoved Autocommands for "*":
	-- Unable to load context query for diff:
	-- ...ed-0.9.5/share/nvim/runtime/lua/vim/treesitter/query.lua:259: query: invalid node type at position 6 for language diff
	-- Show current function at the top of the screen when function does not fit in screen
	-- {
	-- 	"romgrk/nvim-treesitter-context",
	-- 	config = function()
	-- 		require("treesitter-context").setup({
	-- 			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 			throttle = true, -- Throttles plugin updates (may improve performance)
	-- 			max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 			patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
	-- 				-- For all filetypes
	-- 				-- Note that setting an entry here replaces all other patterns for this entry.
	-- 				-- By setting the 'default' entry below, you can control which nodes you want to
	-- 				-- appear in the context window.
	-- 				default = {
	-- 					"class",
	-- 					"function",
	-- 					"method",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- color highlighter
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				user_default_options = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				},
			})
		end,
	},
	-- hint when you type
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},
	-- diagnostics, references, telescope results, quickfix and location lists
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	-- automatically saving your work whenever you make changes to it
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup()
		end,
	},
	-- preview markdown in neovim
	{
		"npxbr/glow.nvim",
		ft = { "markdown" },
	},
	-- smooth scrolling
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end,
	},
	-- highlight and search for todo comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	-- enable repeating supported plugin maps with "."
	{ "tpope/vim-repeat" },
	-- Add/change/delete surrounding delimiter pairs with ease
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- {
	--   "nvim-neorg/neorg",
	--   build = ":Neorg sync-parsers",
	--   dependencies = {
	--     "luarocks.nvim"
	--   },
	--   lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	--   version = "*", -- Pin Neorg to the latest stable release
	--   config = true,
	--   config = function()
	--     require("neorg").setup {
	--       load = {
	--         ["core.defaults"] = {},  -- Loads default behaviour
	--         ["core.concealer"] = {}, -- Adds pretty icons to your documents
	--         ["core.summary"] = {},   -- Creates links to all files in any workspace
	--         ["core.completion"] = {
	--           config = {
	--             engine = "nvim-cmp"
	--           }
	--         },                  -- Creates links to all files in any workspace
	--         -- TODO: neovim +v0.10.0 ["core.ui.calendar"] = {}, -- Opens an interactive calendar for date-related task.
	--         ["core.dirman"] = { -- Manages Neorg workspaces
	--           config = {
	--             workspaces = {
	--               notes = "~/notes",
	--             },
	--           },
	--         },
	--       },
	--     }
	--   end,
	-- },
	-- Metals plugin
	{
		"scalameta/nvim-metals",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local metals_config = require("metals").bare_config()

			-- Example of settings
			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
				useGlobalExecutable = true, -- For NixOS, use system metals binary
			}

			-- *READ THIS*
			-- I *highly* recommend setting statusBarProvider to true, however if you do,
			-- you *have* to have a setting to display this in your statusline or else
			-- you'll not see any messages from metals. There is more info in the help
			-- docs about this
			metals_config.init_options.statusBarProvider = "on"

			-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
			metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Autocmd that will actually be in charging of starting the whole thing
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				-- NOTE: You may or may not want java included here. You will need it if you
				-- want basic Java support but it may also conflict if you are using
				-- something like nvim-jdtls which also works on a java filetype autocmd.
				pattern = { "scala", "sbt", "java" },
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
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
			require("obsidian").setup({
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
			})

			-- Syntax highlighting
			vim.g.vim_markdown_frontmatter = 1
			vim.g.vim_markdown_follow_anchor = 1
			vim.g.vim_markdown_folding_disabled = 1
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "markdown", "markdown_inline" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
			})
		end,
	},
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })- })
