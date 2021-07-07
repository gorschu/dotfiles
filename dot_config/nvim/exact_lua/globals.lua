-- for defaults see :h nvim-default

vim.o.textwidth = 88
vim.o.relativenumber = true
vim.o.title = true
vim.o.visualbell = true
-- set and display listchars
vim.o.list = true
vim.o.listchars="space:·,tab:→·,precedes:«,extends:»,eol:↲,nbsp:␣,trail:•"
vim.o.showbreak="↪"

vim.o.hidden = true

-- create backupdir if it does not exist
local backupdir = vim.env.XDG_DATA_HOME .. "/nvim/backup"
if vim.fn.isdirectory(backupdir) == 0 then
    vim.fn.mkdir(backupdir)
end
vim.o.backupdir = backupdir
vim.o.backup = true -- create backups

vim.o.history = 100
-- undo
vim.o.undofile = true    -- persistent undo
vim.o.undolevels = 1000  -- maximum number of changes that can be undone
vim.o.undoreload = 10000 -- maximum number lines to save for undo on a buffer reload

-- When a bracket is inserted, briefly jump to the matching
-- one. The jump is only done if the match can be seen on thevim.o.showmatch
-- screen. The time to show the match can be set with
-- 'matchtime'.
vim.o.showmatch = true

vim.o.inccommand = "split"


-- Number of spaces that a <Tab> in the file counts for.
vim.o.tabstop = 4
-- Make vim use 4 spaces for indents
vim.o.softtabstop = 4
-- Number of spaces to use for each step of (auto)indent
vim.o.shiftwidth = 4 
-- Use the appropriate number of spaces to insert a <Tab>.
-- Spaces are used in indents with the '>' and '<' commands
-- and when 'autoindent' is on. To insert a real tab when
-- 'expandtab' is on, use CTRL-V <Tab>.
vim.o.expandtab = true
-- When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'. 
-- 'tabstop' is used in other places. A <BS> will delete a 'shiftwidth' worth of space
-- at the start of the line.
vim.o.smarttab = true
-- ensure there is an end of line at the end of file
vim.o.eol = true

-- Ignore case in search patterns.
-- You can use \c to force a pattern to be case insensitive,
-- or \C to force a pattern to be case sensitive.
vim.o.ignorecase = true

-- When doing keyword completion in insert mode, and 'ignorecase' is
-- also on, the case of the match is adjusted depending on the typed text.
vim.o.infercase = true
-- Override the 'ignorecase' option if the search pattern                        
-- contains upper case characters.
vim.o.smartcase = true
                         

-- keep at least 5 lines above/below on screen
vim.o.scrolloff = 5          
-- keep at least 5 columns left/right on screen
vim.o.sidescrolloff = 5 
vim.o.sidescroll = 5         

-- formatting options
vim.o.formatoptions = "tcqjrn"
-- always round indents to multiple of shiftwidth
vim.o.shiftround = true
-- use existing indents for new indents
vim.o.copyindent = true
-- save as much indent structure as possible
vim.o.preserveindent = true


-- More natural splits
vim.o.splitbelow = true
vim.o.splitright = true

-- add extra matching pairs to jump
vim.opt.matchpairs:append { "<:>" }

-- Prevents inserting two spaces after punctuation on a join (J)
vim.o.joinspaces = false

-- only complete to the point of ambiguity
-- vim.o.wildmode = "list:longest"
vim.o.wildmode = "full"

vim.o.spelllang = "en,de"

-- write file on certain command like make et al.
vim.o.autowrite = true

-- set colorcolumn one wider than textwidth
vim.o.colorcolumn = "+1"

-- don't have commands like G,CTRL-D et al. go to the first non blank character in the line
-- but stay in current column (if possible).
vim.o.startofline = false       

-- highlight current cursor line (cursorcolumn also exists, but it's kinda... disturbing)
-- but turn it off straight away to only have the linenumber (CursorLineNr) highlighted
vim.o.cursorline = true          
vim.cmd("highlight CursorLine ctermbg=none guibg=none")

-- folds
vim.o.foldenable = false
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldcolumn = "4"
vim.o.foldnestmax = 5

vim.o.virtualedit = "block"
