vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#bufferline#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_idx_mode'] = 1
vim.g['airline#extensions#ale#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1

vim.api.nvim_set_keymap('n', "<leader>1", "<Plug>AirlineSelectTab1", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>2", "<Plug>AirlineSelectTab2", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>3", "<Plug>AirlineSelectTab3", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>4", "<Plug>AirlineSelectTab4", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>5", "<Plug>AirlineSelectTab5", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>6", "<Plug>AirlineSelectTab6", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>7", "<Plug>AirlineSelectTab7", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>8", "<Plug>AirlineSelectTab8", { noremap = true })
vim.api.nvim_set_keymap('n', "<leader>9", "<Plug>AirlineSelectTab9", { noremap = true })
