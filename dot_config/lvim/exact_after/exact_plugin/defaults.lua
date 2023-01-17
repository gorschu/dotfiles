lvim.colorscheme = "tokyonight"
---- enable builtins
lvim.builtin.treesitter.rainbow.enable = true
-- enable hybrid line numbers
vim.o.relativenumber = true
vim.o.nu = "rnu"

-- null-ls
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  { command = "gofumpt", filetypes = { "go"} },
  { command = "shfmt", filetypes = {"sh"} },
  { command = "shellharden", filetypes = { "sh" } },
  { command = "prettier", filetypes = { "yaml" } },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "shellcheck", filetypes = { "sh" } },
  { command = "pylint", filetypes = { "python" } },
  { command = "mypy", filetypes = { "python" } },
}

-- show extra characters for extra stuff
vim.opt.list = true
vim.opt.listchars:append "tab:⋅"
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "trail:⋅"
vim.opt.listchars:append "eol:"
-- briefly jump to a closing bracket when inserting one
vim.opt.showmatch = true

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
