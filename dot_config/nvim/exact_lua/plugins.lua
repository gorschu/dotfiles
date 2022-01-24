return require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = false}

    -- Color Scheme
    use 'shaunsingh/nord.nvim'

    -- Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'}} }

    -- statusline, tabline
    use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons'} }
    use { 'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}

    -- treesitter syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', requires = { { 'nvim-treesitter/nvim-treesitter-textobjects' } } }

    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    -- use { 'nvim-lua/completion-nvim' } use { 'glepnir/lspsaga.nvim' }
    use { 'hrsh7th/nvim-compe' }

    -- snippets
    use { 'hrsh7th/vim-vsnip', requires = { { 'hrsh7th/vim-vsnip-integ' }, { 'rafamadriz/friendly-snippets' } } }

    -- automatic braces
    use { 'windwp/nvim-autopairs' }
    -- rainbow braces
    use { 'p00f/nvim-ts-rainbow'}

    -- file explorer
    use { 'kyazdani42/nvim-tree.lua', requires = { { 'kyazdani42/nvim-web-devicons' } } }
    -- tag management
    use { 'ludovicchabant/vim-gutentags' }
    use { 'majutsushi/tagbar', opt = true, cmd = "TagbarToggle" }

    -- Go
    use { 'fatih/vim-go', opt = true, ft = 'go' }

    -- git
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'TimUntersberger/neogit', 
        requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }}
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- show indentation levels
    use { 'lukas-reineke/indent-blankline.nvim' }

    -- automatically change cwd to detected roots
    use { 'airblade/vim-rooter' }

    -- misc plugins
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-unimpaired'}
    use { 'tpope/vim-surround'}
    use { 'tpope/vim-dispatch' }
    use { 'tpope/vim-vinegar'}
    use { 'tpope/vim-speeddating'}
    use { 'ntpeters/vim-better-whitespace' }
    use { 'rhysd/clever-f.vim' }
    use { 'jamessan/vim-gnupg' }
    use { 'norcalli/nvim-colorizer.lua'}
    use { 'farmergreg/vim-lastplace' }

    use {'mbbill/undotree', cmd = "UndotreeToggle", opt = true}

    -- linting
    use { 'dense-analysis/ale' }

    -- align stuff, move faster, comments
    use { 'junegunn/vim-easy-align' }
    use { 'easymotion/vim-easymotion' }
    use { 'b3nj5m1n/kommentary' }

    -- markdown
    use {'iamcco/markdown-preview.nvim', config = "vim.call('mkdp#util#install')"}

    -- tmux integration
    use {'christoomey/vim-tmux-navigator'}
    use {'tmux-plugins/vim-tmux-focus-events'}

    -- detect python venvs
    use { 'rafi/vim-venom', ft = 'python' }

    use { 'mitsuhiko/vim-jinja', ft = {'jinja', 'jinja2'} }
    use { 'chrisbra/csv.vim', ft = {'csv'} }
    use { 'lervag/vimtex', ft = 'tex' }

    -- edit files as sudo
    use {'lambdalisue/suda.vim'}

    -- registers
    -- preview registers
    use { 'tversteeg/registers.nvim' }
    -- register clipboard manager
    use { 'AckslD/nvim-neoclip.lua', config = function()
        require('neoclip').setup()
    end}

    -- less distractions
    use { 'folke/twilight.nvim', config = function()
        require("twilight").setup()
    end,
    opt = true, cmd = {'Twilight', 'TwilightEnable', 'TwilighDisable' }
    }
    use { 'folke/zen-mode.nvim', config = function()
        require("zen-mode").setup()
    end,
    opt = true, cmd = { 'ZenMode' }
    }
end)
