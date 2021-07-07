-- Auto install packer.nvim if not exists
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]] -- only required if packer is an opt plugin
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

vim.cmd 'au TextYankPost * lua vim.highlight.on_yank { on_visual = true }'
vim.g.mapleader = ","

require('globals')
require('plugins')
require('functions')
require('keymappings')
require('colorscheme')
require('completeopts')
require('lsp')
require('plugins/treesitter')
require('plugins/compe')
require('plugins/autopairs')
require('plugins/airline')
require('plugins/telescope')

vim.g.gutentags_define_advanced_commands = 1
vim.g.gutentags_cache_dir = vim.loop.os_homedir() .. '/.cache/gutentags'
vim.g.gutentags_generate_on_new = 1
vim.g.gutentags_generate_on_missing = 1
vim.g.gutentags_generate_on_write = 1
vim.g.gutentags_generate_on_empty_buffer = 0
vim.g.gutentags_file_list_command = 'rg --files'

vim.api.nvim_set_keymap('n', '<F9>', '<cmd>TagbarToggle<cr>', { noremap = true, silent = true } )
vim.g.tagbar_autoclose = 0

vim.api.nvim_set_keymap('n', '<F8>', '<cmd>UndotreeToggle<cr>', {noremap = true, silent= true})

-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()

vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>tr', '<cmd>NvimTreeRefresh<cr>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>NvimTreeFindFile<cr>', { noremap = true})

require('kommentary.config').use_extended_mappings()
require('gitsigns').setup()

require("bufferline").setup{
	options = {
		numbers = "ordinal",
		numberstyle = "none",
		always_show_bufferline = true,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    return "("..count..")"
                end,
                offsets = {{filetype = "NvimTree", text = "NvimTree", text_align = "left", highlight = "Directory" }, { filetype = "tagbar", text = "Tagbar", text_align = "right", highlight = "Directory"}, { filetype="packer", text = "Packer", text_align="left", highlight="Directory"}},
		sort_by = "relative_directory"

	}
}
vim.api.nvim_set_keymap('n', "<leader>bp", "<cmd>BufferLinePick<cr>", { noremap = true, silent = true })

vim.g.rooter_silent_chdir = 1
vim.g.rooter_change_directory_for_non_project_files = 'current'

vim.g.ale_fix_on_save = 1
-- vim.g.ale_fixers = "{ 'lua': ['remove_trailing_lines'] }"

vim.api.nvim_set_keymap('n', '<A-j>', ':move+<cr>==', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<A-k>', ':move-2<cr>==', { noremap = true, silent = true} )
vim.api.nvim_set_keymap('v', '<A-j>', ":move \'>+1<cr>==gv", {noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":move \'<-2<CR>==gv", {noremap = true, silent = true })

require('lualine').setup({options = { theme = 'gruvbox'}})

vim.g.clever_f_across_no_line = 1
vim.g.clever_f_timeout_ms = 3000

vim.g.EasyMotion_samrtcase = 1
vim.g.EasyMotion_use_smartsign_us = 1


-- Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vim.api.nvim_set_keymap('x', 'ga', [[<Plug>(EasyAlign)]], { noremap = False})

-- Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
vim.api.nvim_set_keymap('n', 'ga', [[<Plug>(EasyAlign)]], { noremap = False})

vim.g.suda_smart_edit = 1
