-- bars
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>TagbarToggle<cr>', { noremap = true, silent = true } )
vim.g.tagbar_autoclose = 0
-- nvimtree
vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<cr>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>tr', '<cmd>NvimTreeRefresh<cr>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>NvimTreeFindFile<cr>', { noremap = true})

vim.api.nvim_set_keymap('n', '<F8>', '<cmd>UndotreeToggle<cr>', {noremap = true, silent= true})

-- local saga = require 'lspsaga'
-- saga.init_lsp_saga()

vim.g.rooter_silent_chdir = 1
vim.g.rooter_change_directory_for_non_project_files = 'current'

vim.g.ale_fix_on_save = 1
-- vim.g.ale_fixers = "{ 'lua': ['remove_trailing_lines'] }"

vim.g.clever_f_across_no_line = 1
vim.g.clever_f_timeout_ms = 3000

vim.g.EasyMotion_samrtcase = 1
vim.g.EasyMotion_use_smartsign_us = 1

-- Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vim.api.nvim_set_keymap('x', 'ga', [[<Plug>(EasyAlign)]], { noremap = False})

-- Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
vim.api.nvim_set_keymap('n', 'ga', [[<Plug>(EasyAlign)]], { noremap = False})

vim.g.suda_smart_edit = 1

