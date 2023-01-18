-- everything that can't be done in after/... lives here
lvim.format_on_save.enabled = true
lvim.colorscheme = "tokyonight"
--
-- null-ls
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  { command = "gofumpt", filetypes = { "go"} },
  { command = "goimports", filetypes = { "go"} },
  { command = "goimports_reviser", filetypes = { "go" } },
  { command = "stylua", filetypes = { "lua" } },
  { command = "shfmt", filetypes = {"sh"} },
  { command = "shellharden", filetypes = { "sh" } },
  { command = "prettier", filetypes = { "yaml" } },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "shellcheck", filetypes = { "sh" } },
  { command = "pylint", filetypes = { "python" } },
  { command = "mypy", filetypes = { "python" } },
  { command = "staticcheck", filetypes = { "go" } },
  { command = "golangci_lint", filetypes = { "go" } },
  { command = "revive", filetypes = { "go" }},
}

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
