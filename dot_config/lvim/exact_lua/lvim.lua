-- everything that can't be done in after/... lives here
lvim.format_on_save.enabled = true
lvim.colorscheme = "tokyonight-night"

---- enable builtins
lvim.builtin.treesitter.rainbow.enable = true
--
-- copilot setup
-- see https://www.lunarvim.org/docs/plugins/extra-plugins
lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

-- trouble
lvim.builtin.which_key.mappings["t"] = {
	name = "Diagnostics",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}
--
-- null-ls
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python" } },
	{ command = "isort", filetypes = { "python" } },
	{ command = "gofumpt", filetypes = { "go" } },
	{ command = "goimports", filetypes = { "go" } },
	{ command = "goimports_reviser", filetypes = { "go" } },
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "shfmt", filetypes = { "sh" } },
	{ command = "shellharden", filetypes = { "sh" } },
	{ command = "prettier", filetypes = { "yaml" } },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "shellcheck", filetypes = { "sh" } },
	{ command = "pylint", filetypes = { "python" } },
	{ command = "mypy", filetypes = { "python" } },
	{ command = "staticcheck", filetypes = { "go" } },
	{ command = "golangci_lint", filetypes = { "go" } },
	{ command = "revive", filetypes = { "go" } },
})

lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"go",
	"lua",
	"markdown",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}
lvim.lsp.installer.setup.ensure_installed = {
	"ansiblels",
	"bashls",
	"dockerls",
	"gopls",
	"jsonls",
	"marksman",
	"pyright",
	"sumneko_lua",
}
