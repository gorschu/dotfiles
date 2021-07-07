-- Auto-Apply when editing chezmoi-managed files
vim.api.nvim_command([[
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --no-tty --source-path %
]])


-- set options for mutt mail-editing
vim.api.nvim_command([[
augroup fileype_mail
    autocmd!
    autocmd BufNew, BufRead /tmp/azmo/mutt-* set ft=mail " set filetype to mail
    " Support Format-Flowed in email (mutt).
    autocmd FileType mail setl list
    " Don't highlight whitespace, format flowed needs them
    " Don't match on FileType mail, because it's just not working
    au VimEnter /tmp/azmo/mutt-* ToggleWhitespace

    autocmd Filetype mail command! Fix call FixFlowed()
    autocmd Filetype mail autocmd BufWritePre <buffer> call FixFlowed()
    autocmd Filetype mail autocmd BufWritePre <buffer> call FixIndented()

    autocmd FileType mail setl formatprg=par\ -w72qr  " use par as reformatter on gq
augroup END
]])

-- general filetype options
vim.api.nvim_command([[
augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.j2 setl ft=jinja
    autocmd BufNewFile,BufRead *.jinja setl ft=jinja
    autocmd Filetype yaml setl tabstop=2
    autocmd Filetype yaml setl shiftwidth=2
]])

-- misc
vim.api.nvim_command([[
augroup misc
    autocmd!
    " call vim-better-whitespace to remove extra whitespace
    autocmd FileType python,sh,zsh,json,yaml autocmd BufWritePre <buffer> StripWhitespace
]])
