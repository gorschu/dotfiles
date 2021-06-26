vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- clear last search
vim.api.nvim_set_keymap('n', '<leader>/', [[<cmd>nohlsearch<cr>]], { noremap = true, silent = true})
