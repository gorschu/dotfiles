return require('packer').startup(function()

    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = false}

    -- Color Scheme
    use { "rktjmp/lush.nvim" , requires = {"npxbr/gruvbox.nvim" } }

    -- Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'}} }

    -- use { 'vim-airline/vim-airline', requires = { { 'vim-airline/vim-airline-themes'} }
    -- }
    use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true} }
    use { 'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}

    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    -- use { 'nvim-lua/completion-nvim' } use { 'glepnir/lspsaga.nvim' }
    use { 'hrsh7th/nvim-compe' }
    use { 'hrsh7th/vim-vsnip', requires = { { 'hrsh7th/vim-vsnip-integ' }, { 'rafamadriz/friendly-snippets' } } }
    use { 'windwp/nvim-autopairs' }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', requires = { { 'nvim-treesitter/nvim-treesitter-textobjects' } } }

    use { 'ludovicchabant/vim-gutentags' } use { 'majutsushi/tagbar', opt = true }
    -- Go
    use { 'fatih/vim-go', opt = true }

    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    use { 'lukas-reineke/indent-blankline.nvim', branch = "lua"}

    use { 'airblade/vim-rooter' }

    use { 'kyazdani42/nvim-tree.lua', requires = { { 'kyazdani42/nvim-web-devicons' } } }

    use { 'tpope/vim-fugitive' }
    use { 'tpope/vim-repeat' }
    use {'tpope/vim-unimpaired'}
    use { 'tpope/vim-surround'}
    use { 'tpope/vim-dispatch' }
    use {'tpope/vim-vinegar'}
    use { 'ntpeters/vim-better-whitespace' }
    use { 'rhysd/clever-f.vim' }


    use { 'dense-analysis/ale' }

    use { 'jamessan/vim-gnupg' }

    use { 'junegunn/vim-easy-align' }

    use { 'b3nj5m1n/kommentary' }

    use { 'easymotion/vim-easymotion' }

    use {'iamcco/markdown-preview.nvim', config = "vim.call('mkdp#util#install')"}

    use {'christoomey/vim-tmux-navigator'}
    use {'tmux-plugins/vim-tmux-focus-events'}

    use { 'p00f/nvim-ts-rainbow '}

    -- detect python venvs
    use { 'rafi/vim-venom' }

end)
