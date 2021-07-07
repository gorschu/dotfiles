-- functions for mutt's format flowed
vim.api.nvim_command([[
" source: https://github.com/marklee77/mailtools.vim/blob/master/ftplugin/mail.vim
" sidenote: email needs to die in the fire of a 1000 suns. format flowed is
" crap, mildy put.
function! FixFlowed()
    let pos = getpos('.')
    let lnum = pos[1]

    " strip off trailing spaces, except on current line
    execute 'silent! 1;' . (pos[1] - 1) . 's/\m\s*$//'
    execute 'silent! '   . (pos[1] + 1) . ';$s/\m\s*$//'

    " enforce one space after header names
    silent! 1;/\m^$/s/\m^\w\+:\zs\s*\%(\_S\)\@=/ /

    " header lines should end with a space if they flow into the next line
    silent! 1;/\m^$/s/\m\S\zs\%(\_$\n \)\@=/ /

    " put a space back after signature delimiter
    silent! $?\m^--$?s/$/ /

    " compress quote characters
    while search('^>\+\s\+>', 'w') > 0
        silent! s/\m^>\+\zs\s\+>/>/
    endwhile
    silent! %s/\m^>\+\zs\%([^[:space:]>]\)\@=/ /

    " un-space stuff from
    silent! 1/\m^$/;/\m^-- $/s/\m^\s\(\s*\)\zeFrom\_s/\1/

    " put spaces back at ends of lines in paragraph lines, where paragraph lines
    " are defined as lines including at least 2 sequential letters, followed by
    " lines with the same quote prefix (nothing or some number of > followed by
    " a space) that starts with no more than 3 spaces followed by an optional
    " opening punctuation mark, one of "*([{@~|>, that is immediately followed
    " by a letter or digit.
    silent! 1/\m^$/;/\m^-- $/s/\m^\(>\+\s\|\) \{,3}\S*\a\{2,}.*\S\zs\%(\_$\n\1 \{,3}["*(\[{@~|<]\=[0-9A-Za-z]\)\@=/ /

    " space stuff from
    silent! 1/\m^$/;/\m^-- $/s/\m^\ze\s*From\_s/ /

    call setpos('.', pos)
endfunction

function! FixIndented()
  " remove spaces at end of indented lines
  silent! %s/^\s.*\zs \+$//
endfunction
]])
