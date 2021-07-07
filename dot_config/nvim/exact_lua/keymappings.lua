vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- clear last search
vim.api.nvim_set_keymap('n', '<leader>/', [[<cmd>nohlsearch<cr>]], { noremap = true, silent = true})

-- highlight last inserted text
vim.api.nvim_set_keymap('n', 'gV', "`[v`]", { noremap = true })

-- better indentation
-- Reselect visual block after indent/outdent
-- normally vim loses its selection after pressing < or > once
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true})

-- move text around using arrow keys
vim.api.nvim_set_keymap('n', '<Left>', '<<', {noremap = false})
vim.api.nvim_set_keymap('n', '<Right>', '>>', {noremap = false})
vim.api.nvim_set_keymap('v', '<Left>', '<gv', { noremap = false})
vim.api.nvim_set_keymap('v', '<Right>', '>gv', { noremap = false})
-- unimpaired re-usage to move text
vim.api.nvim_set_keymap('n', '<Up>', '[e', {noremap = false})
vim.api.nvim_set_keymap('n', '<Down>', ']e', {noremap = false})
vim.api.nvim_set_keymap('v', '<Up>', '[egv', {noremap = false})
vim.api.nvim_set_keymap('v', '<Down>', ']egv', {noremap = false})

-- delete buffer, but keep current split by moving to previous buffer first
vim.api.nvim_set_keymap('n','<leader>bd', [[<cmd>bp|bd #<cr>]], { noremap = false, silent = true})

