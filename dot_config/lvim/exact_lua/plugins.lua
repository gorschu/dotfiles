-- plugins
lvim.plugins = {
	{ "catppuccin/nvim", as = "catppuccin" },
	{ "gpanders/editorconfig.nvim" }, -- no longer needed in nvim 0.9.0
	{ "christoomey/vim-tmux-navigator" }, -- better tmux navigation
	{
		"nacro90/numb.nvim", -- peek before jumping to line
		event = "BufRead",
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"ggandor/leap.nvim", -- awesome navigation
		config = function()
			require("leap").setup({
				require("leap").add_default_mappings(),
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	{ "theHamsta/nvim-dap-virtual-text" },
	{
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
				})
			end, 100)
		end,
	},
	{ "zbirenbaum/copilot-cmp", after = { "copilot.lua", "nvim-cmp" },
		config = function()
			require("copilot_cmp").setup()
		end
	},
	{
		"ray-x/go.nvim",
		config = function()
			require("go").setup()
		end,
		requires = "ray-x/guihua.lua",
	},
	{ "folke/trouble.nvim", cmd = "TroubleToggle" },
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},
	{ -- Show Tags in Outline (for LSP)
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				open_automatic = true,
				close_automatic_events = { "unsupported" },
			})
		end,
	},
	{
		"f-person/git-blame.nvim", -- show git blame for every line in virtual text
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
			vim.g.gitblame_enabled = 0
		end,
	},
	-- treesitter
	{ "p00f/nvim-ts-rainbow" },
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	{ "tpope/vim-repeat" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim", after = { "mason.nvim", "null-ls.nvim" } },
}
