-- enable hybrid line numbers
vim.o.relativenumber = true
vim.o.nu = "rnu"

-- show extra characters for extra stuff
vim.opt.list = true
vim.opt.listchars:append("tab:⋅")
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("eol:")
-- briefly jump to a closing bracket when inserting one
vim.opt.showmatch = true

-- ensure installation of Mason utils
require("mason-tool-installer").setup({
	ensure_installed = {
		"golangci-lint",
		"bash-language-server",
		"lua-language-server",
		"vim-language-server",
		"gopls",
		"stylua",
		"shellcheck",
		"editorconfig-checker",
		"gofumpt",
		"golines",
		"gomodifytags",
		"gotests",
		"impl",
		"json-to-struct",
		"luacheck",
		"misspell",
		"revive",
		"shellcheck",
		"shfmt",
		"staticcheck",
		"vint",
	},
	auto_update = false,
	run_on_start = true,
	start_delay = 3000, -- 3 second delay
})
-- folding (use treesitter)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 20 -- set to high number to not automatically start folded

-- toggleterm
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
