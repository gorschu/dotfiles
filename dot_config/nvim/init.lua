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
require('plugins/gutentags')
require('plugins/nvimtree')
require('plugins/bufferline')
require('plugins/misc')

require('kommentary.config').use_extended_mappings()
require('gitsigns').setup()

require('lualine').setup({options = { theme = 'gruvbox'}})

