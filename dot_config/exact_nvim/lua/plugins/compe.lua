require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = false;
  };
}

vim.api.nvim_set_keymap('i', '<C-Space>', [[compe#complete()]], { noremap = true, silent = true, expr = true })
-- handled by autopairs
-- vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], { noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<C-e>', [[compe#close('<C-e>')]], { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-f>',  [[compe#scroll({ 'delta': +4 })]], { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-d>',  [[compe#scroll({ 'delta': -4 })]], { noremap = true, silent = true, expr = true })
