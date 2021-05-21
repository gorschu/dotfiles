" download vim-plug if missing
if empty(glob("~/.cache/nvim/autoload/plug.vim"))
    silent! execute '!curl --create-dirs -fsSLo ~/.cache/nvim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * silent! PlugInstall
endif

set rtp+=~/.cache/nvim

" source in our own functions
source $HOME/.config/nvim/functions
source $HOME/.config/nvim/plugins/noplaintext.vim

" plugins {{{
call plug#begin('~/.cache/nvim/plugged')

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'petobens/poet-v'
let g:poetv_executables = ['poetry']

" 'Self'-Vim plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arcticicestudio/nord-vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf'                         " fuzzy finder
Plug 'junegunn/fzf.vim'                     " fuzzy finder

Plug 'airblade/vim-rooter'                  " intelligent autochdir
Plug 'christoomey/vim-tmux-navigator'       " better tmux integration
Plug 'tmux-plugins/vim-tmux-focus-events'   " better tmux integration
Plug 'junegunn/rainbow_parentheses.vim'     " Bracket highlighting
Plug 'tpope/vim-vinegar'                    " better netrw

" Text-Productivity
Plug 'dyng/ctrlsf.vim'          " ack-like searching and editing
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'       " surround stuff
Plug 'tpope/vim-dispatch'       " dispatch vim jobs
Plug 'tpope/vim-eunuch'         " unix helpers
Plug 'tommcdo/vim-exchange'     " exchange lines
Plug 'Lokaltog/vim-easymotion'  " move fast and stuff
Plug 'junegunn/vim-easy-align'  " align stuff
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'  " Snippets
Plug 'rhysd/clever-f.vim'       " better f and t commands
Plug 'jamessan/vim-gnupg'
Plug 'ntpeters/vim-better-whitespace'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

" Programming
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'fisadev/vim-isort'                " :ISort, needs global isort avail
Plug 'fs111/pydoc.vim'                  " :Pydoc
Plug 'michaeljsmith/vim-indent-object'  " extra objects for python
Plug 'sbdchd/neoformat'                 " autoformat source
Plug 'ludovicchabant/vim-gutentags'     " automatically generate tags
Plug 'preservim/nerdcommenter'          " sexy commenting
Plug 'tpope/vim-fugitive'               " git awesomeness
Plug 'jreybert/vimagit'                 " dito

Plug 'airblade/vim-gitgutter'           " show git changes in gutter
Plug 'dense-analysis/ale'               " automatic linting and syntax checking
Plug 'majutsushi/tagbar'                " Tagbar
Plug 'cohama/lexima.vim'                " handle brackets
Plug 'mbbill/undotree'                  " massively great undo

if executable('go')
    Plug 'fatih/vim-go'                 " everything for golang
endif

" Filetypes
Plug 'saltstack/salt-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'pearofducks/ansible-vim' " ansible
Plug 'mitsuhiko/vim-jinja', { 'for': 'jinja' }
Plug 'chrisbra/csv.vim'
Plug 'cespare/vim-toml'
Plug 'ap/vim-css-color'

" Writing
Plug 'lervag/vimtex'
Plug 'tpope/vim-speeddating'    " for vim-orgmode, but great nonetheless
Plug 'plasticboy/vim-markdown'
Plug 'https://github.com/alok/notational-fzf-vim'

" Needs to be loaded last
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

call plug#end()

filetype plugin indent on     " required

" }}}

" {{{ general stuff

" set menu language and message language to english
if has('unix')
    language messages C
else
    language messages en
endif

" set font if we are running a gui
if has("gui_running")
    if has('unix') && has('gui_gtk2')
        " linux
        set guifont=Monospace\ 10
        " set guifont=Source\ Code\ Pro\ 10
    elseif has('unix') && has("gui_macvim")
        " mvim
        set guifont=Menlo:h12
    elseif has('gui_win32')
        " win32
        set guifont=DejaVu_Sans_Mono_For_Powerline:h10
    endif
    " turn off toolbar and menu, also scrollbars
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
endif

" setup save/backup/swap environment
call InitializeDirectories()

"}}}

" settings start here  "{{{

let mapleader = ","     " map my leader key to a comma

" colors
syntax enable
set background=dark
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1

colorscheme nord

set updatetime=250       " update stuff after 2.5s
set title                " try to set window title
set pastetoggle=<INSERT> " hit f2 while in insert mode for paste mode
set encoding=utf-8       " use utf-8 internally
set fileencodings=utf-8  " we want everything to be utf-8 encoded
set undofile             " persistent undo
set undolevels=1000      " maximum number of changes that can be undone
set undoreload=10000     " maximum number lines to save for undo on a buffer reload
set colorcolumn=+1       " set colorcolumn one wider than textwidth
set textwidth=88         " Maximum width of text that is being inserted. A longer
                         " line will be broken after white space to get this width.
set backup               " backups are nice ...
set lazyredraw           " only redraw if we really need to.
set hidden               " The current buffer can be put to the background without
                         " writing to disk
                         " When a background buffer becomes current again,
                         " marks and undo-history are remembered.
set history=100          " remember 100 history items in .viminfo
set noerrorbells         " No error bells please
set visualbell           " seriously...
set scrolloff=5          " keep at least 5 lines above/below on screen
set sidescrolloff=5      " keep at least 5 lines left/right on screen
set sidescroll=5         " dito

set tabstop=4            " Number of spaces that a <Tab> in the file counts for.
set softtabstop=4        " Make vim use 4 spaces for indents
set shiftwidth=4         " Number of spaces to use for each step of (auto)indent.
set expandtab            " Use the appropriate number of spaces to insert a <Tab>.
                         " Spaces are used in indents with the '>' and '<' commands
                         " and when 'autoindent' is on. To insert a real tab when
                         " 'expandtab' is on, use CTRL-V <Tab>.
set smarttab             " When on, a <Tab> in front of a line inserts blanks
                         " according to 'shiftwidth'. 'tabstop' is used in other
                         " places. A <BS> will delete a 'shiftwidth' worth of space
                         " at the start of the line.
set eol                  " ensure there is an end of line at end of file
set nostartofline        " don't have commands like G,CTRL-D et al. go to the first non blank character in the line
                         " but stay in current column (if possible).
set laststatus=2         " Always show the statusline
set showcmd              " Show (partial) command in status line.

set number               " Show line numbers.
set ruler                " Show the line and column number of the cursor position,
                         " separated by a comma.
set cursorline           " highlight current cursor line (cursorcolumn also exists, but it's kinda... disturbing)
                         " but turn it off straight away to only have the linenumber (CursorLineNr) highlighted
hi  CursorLine ctermbg=none guibg=none
set showmatch            " When a bracket is inserted, briefly jump to the matching
                         " one. The jump is only done if the match can be seen on the
                         " screen. The time to show the match can be set with
                         " 'matchtime'.
set hlsearch             " When there is a previous search pattern, highlight all
                         " its matches.
set incsearch            " While typing a search command, show immediately where the
                         " so far typed pattern matches.
set ignorecase           " Ignore case in search patterns.
                         " You can use \c to force a pattern to be case insensitive,
                         " or \C to force a pattern to be case sensitive.
set infercase            " When doing keyword completion in insert mode, and 'ignorecase' is
                         " also on, the case of the match is adjusted depending on the typed text.
set smartcase            " Override the 'ignorecase' option if the search pattern
                         " contains upper case characters.

set backspace=2          " Influences the working of <BS>, <Del>, CTRL-W
                         " and CTRL-U in Insert mode. This is a list of items,
                         " separated by commas. Each item allows a way to backspace
                         " over something.

set nojoinspaces         " Prevents inserting two spaces after punctuation on a join (J)
set virtualedit=block    " allow blocks with bounds outside of text (blanks)
set autoindent           " Copy indent from current line when starting a new line
                         " (typing <CR> in Insert mode or when using the "o" or "O"
                         " command).
set shiftround           " always round indents to multiple of shiftwidth
set copyindent           " use existing indents for new indents
set preserveindent       " save as much indent structure as possible
set formatoptions=tcrqln " t - autowrap to textwidth
                         " c - autowrap comments to textwidth
                         " r - autoinsert comment leader with <Enter>
                         " q - allow formatting of comments with :gq
                         " l - don't format already long lines when enterting insert
                         " n - recognize numbered (any) lists
set foldenable           " enable folds
set foldmethod=marker    " enable markers by default,
                         " one can always put 'vim: set foldmethod=indent'
                         " as a comment somewhere
set foldcolumn=4         " set 6 character width foldcolumn (left)
set foldnestmax=5        " five levels deep nested max
"set foldlevel=1          " automatically start folding on level 1

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

set matchpairs+=<:>

set ssop-=options        " do not store global and local values in a session
set ssop-=folds          " do not store folds"

set wildmenu                " tab completion for commands shows possible matches
set wildmode=full           " completion mode
" set wildmode=list:longest " behave similar to a shell, i.e. complete only up
                            " to the point of ambiguity
set completeopt=menuone,longest,preview " Omnicompletion menu behaviour
set maxmempattern=2000      " double default kib value for pattern processing
set spelllang=en,de         " set region to american english by default

" search for tags file in current directory and work up until you hit $HOME
set tags=./tags,tags;
set autowrite               " save on make (GoBuild et al)

" show trailing whitespace and tabs
"set list listchars=tab:»·,trail:␣,extends:»,eol:↩
set list listchars=tab:→·,precedes:«,extends:»,eol:↲,nbsp:␣,trail:•
set showbreak=↪
"set list listchars=tab:»·,trail:·,extends:»,eol:¬
"set list listchars=tab:»•,trail:•,extends:»

" nvim
if has('nvim')
    " Fix C-h issue. https://github.com/neovim/neovim/issues/2048
    nmap <BS> <C-W>h
    " another workaround is https://github.com/neovim/neovim/issues/2048#issuecomment-78045837

    let $TMUX_TUI_ENABLE_SHELL_CURSOR=1
    set termguicolors                   " enable true color support.
    set inccommand=split                " show split for incremental commands (%s/)

    "let g:python3_host_prog = $WORKON_HOME . "/neovim-python3/bin/python"
endif

if !has('nvim')
    set ttyfast " Send more characters at a given time
endif
"}}}

" {{{ plugin configuration

" clever-f
let g:clever_f_across_no_line = 1
let g:clever_f_timeout_ms = 3000

" Rooter
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'

" Use gpg2 if available because it's 2016
if executable('gpg2')
    let g:GPGExecutable = 'gpg2'
endif

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" neoformat
let g:neoformat_only_msg_on_error = 1

let g:neoformat_enabled_python = ['black']
let g:neoformat_enabled_yaml = ['prettier']
let g:neoformat_enabled_go = ['goreturns']

let g:neoformat_yaml_prettier = {'args': '--no-bracket-spacing'}
let g:neoformat_yaml_ansible_prettier = {'args': '--no-bracket-spacing'}

augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup END
" if there is an formatprg present, use that one
" let g:neoformat_try_formatprg = 1

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" easy-motion
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" vim-pandoc
let g:pandoc#formatting#mode='hA'
let g:pandoc#formatting#smart_autoformat_on_cursor_moved = 1
let g:pandoc#formatting#textwidth = 120
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 1

" vim-go
let g:go_auto_type_info = 1
let g_go_fmt_command = "goreturns"
let g:go_fmt_autosave = 0 " neoformat is handling that


" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#ale#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" nerdtree
map <F7> :NERDTreeToggle<CR>

" fzf
let g:fzf_preview_window = 'right:60%'


" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '40%'}

" Customize fzf colors to match your color scheme
"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
"  \ 'bg':      ['bg', 'Normal'],
"  \ 'hl':      ['fg', 'Comment'],
"  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"  \ 'hl+':     ['fg', 'Statement'],
"  \ 'info':    ['fg', 'PreProc'],
"  \ 'border':  ['fg', 'Ignore'],
"  \ 'prompt':  ['fg', 'Conditional'],
"  \ 'pointer': ['fg', 'Exception'],
"  \ 'marker':  ['fg', 'Keyword'],
"  \ 'spinner': ['fg', 'Label'],
"  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
"let g:fzf_history_dir = '~/.local/share/fzf-history'
"
noremap <leader>b :Buffers<cr>
noremap <leader>t :Tags<cr>
noremap <leader>r :History<cr>
noremap <leader>f :Files<cr>
noremap <leader>gf :GFiles<cr>

" vimtex
let g:tex_flavor='latex'

" neovim-completion-manager
" Hide menu on enter
imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
imap <expr> <Plug>(expand_or_nl) (cm#completed_is_snippet() ? "\<C-j>":"\<CR>")

" UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<c-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets", "mysnippets-private"]
let g:snips_author = "Gordon Schulz (azmo)"
let g:snips_email = "gordon.schulz@gmail.com"
let g:snips_github = "https://github.com/azmd"

" tagbar
nmap <F9> :TagbarToggle<CR>
" don't automatically close on tag select
let g:tagbar_autoclose = 0

" gundo
nnoremap <F8> :UndotreeToggle<CR>              " Toggle Undotree with F8

" incsearch
let g:incsearch#magic = '\m' " magic
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)zv
map N  <Plug>(incsearch-nohl-N)zv
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

" gutentags
let g:gutentags_define_advanced_commands=1
let g:gutentags_cache_dir=$HOME.'/tmp/gutentags'
"}}}

" autocmd and filetype customization  "{{{

" Go to the last cursor location when a file is opened, unless this is a
" git commit (in which case it's annoying)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") &&
            \ &filetype != "gitcommit" |
            \ execute("normal `\"") |
            \ endif

" Auto-Apply when editing chezmoi-managed files
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path %

" set options for mutt mail-editing
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

augroup filetype_python
    autocmd!
    " pep8-compliance (two spaces before inline comment) commentstring for python
    autocmd FileType python setlocal commentstring=\ \ #%s
    " and textwidth at 79
    autocmd FileType python setlocal tw=79
    autocmd FileType python setlocal wrap
    autocmd FileType python setlocal nocopyindent
augroup END

augroup filetype_go
    autocmd!
    autocmd FileType go nmap <leader>gb :<C-u>call BuildGoFiles()<CR>
    autocmd FileType go nmap <leader>gr <Plug>(go-run)
    autocmd FileType go nmap <Leader>gc <Plug>(go-coverage-toggle)
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.otl setl ft=votl  " set to filetype votl for outliner files
    autocmd BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile
    autocmd BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
    autocmd FileType json setlocal foldmethod=syntax   " set foldmethod to syntax for json files
    autocmd FileType markdown setlocal tw=80 " set textwidth to 80 when doing markdown
    autocmd BufNewFile,BufRead *.j2 setl ft=jinja
    autocmd BufNewFile,BufRead *.jinja setl ft=jinja
    autocmd Filetype yaml setl tabstop=2
    autocmd Filetype yaml setl shiftwidth=2
augroup END

augroup gitcommit
    autocmd!
    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
    autocmd Filetype gitcommit setl tw=72
augroup END

" from elzr/vim-json
augroup json_autocmd
  autocmd!
  autocmd FileType json setl autoindent
  autocmd FileType json setl formatoptions=tcq2l
  autocmd FileType json setl textwidth=78 shiftwidth=2
  autocmd FileType json setl softtabstop=2 tabstop=8
  autocmd FileType json setl expandtab
  autocmd FileType json setl foldmethod=syntax
augroup END

augroup rainbow
  autocmd!
  autocmd FileType * RainbowParentheses
augroup END

augroup misc
    autocmd!
    " initialize a new backup extension pre write
    autocmd BufWritePre * call InitNewBackupExtension()
    " call vim-better-whitespace to remove extra whitespace
    autocmd FileType python,sh,zsh,json,yaml autocmd BufWritePre <buffer> StripWhitespace
augroup END
"}}}

" keyboard mappings and custom commands "{{{

" use normal regexp matching
" nnoremap / /\v
nmap <silent> <leader>/ :nohlsearch<CR>     " clear last search by pressing leader /

nmap <silent> <leader>S :set spell!<CR>     " toggle spellchecking by hitting leader+S
vnoremap <leader>s :sort<CR>                " sort selected/all text alphabetically by hitting leader+s

nmap <silent> <leader>N :NERDTreeFind<CR>
" Move visual block with J and K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" remap j and key, this does not skip "fake" lines when vim is visually
" restrained by the terminal
" move vertically by *visual* line
nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]

" better indentation
" Reselect visual block after indent/outdent
" normally vim loses its selection after pressing < or > once
vnoremap < <gv
vnoremap > >gv

" remap cursor keys to be more efficient
" map up/down arrow keys to unimpaired commands
"nmap <Up> [e
"nmap <Down> ]e
"vmap <Up> [egv
"vmap <Down> ]egv
"
"" map left/right arrow keys to indendation
"nmap <Left> <<
"nmap <Right> >>
"vmap <Left> <gv
"vmap <Right> >gv

" or just disable them if you get fed up
"inoremap  <Up>     <NOP>
"inoremap  <Down>   <NOP>
"inoremap  <Left>   <NOP>
"inoremap  <Right>  <NOP>
"noremap   <Up>     <NOP>
"noremap   <Down>   <NOP>
"noremap   <Left>   <NOP>
"noremap   <Right>  <NOP>

noremap <Up> 3<C-W>+
noremap <Down> 3<C-W>-
noremap <Left> 3<C-W>>
noremap <Right> 3<C-W><

" vim-tmux-navigator does it
"nmap <silent> <C-l> :wincmd l<CR>
"nmap <silent> <C-k> :wincmd k<CR>
"nmap <silent> <C-h> :wincmd h<CR>
"nmap <silent> <C-j> :wincmd j<CR>

" Remapping for unimpaired
nmap ü [
nmap ä ]
omap ü [
omap ä ]
xmap ü [
xmap ä ]

" use jk to exit insert mode
inoremap    jk      <ESC>

" call OpenCabling for Connect Cabling files
command! -nargs=1 Cabling call OpenCabling(<f-args>)

" if we open a ro file without sudo, w!! will take care of that
cmap w!! w !sudo tee > /dev/null %

" delete current buffer by switching to another first -> effectively keeping my splits
nmap ,bd :b#<bar>bd#<CR>

"}}}

let g:ale_linters = {
\   'go': ['golangci-lint'],
\   'python': ['pylama'],
\}


let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

"let g:NERDTreeFileExtensionHighlightFullName = 1
"let g:NERDTreeExactMatchHighlightFullName = 1
"let g:NERDTreePatternMatchHighlightFullName = 1
"

let g:nv_search_paths = ['~/notes']


let g:vim_markdown_folding_level = 2
let g:vim_markdown_folding_style_pythonic = 1
