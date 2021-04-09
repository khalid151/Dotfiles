return function(use)
    -- Manage packer
    use 'wbthomason/packer.nvim'

    -- General
    use 'mhinz/vim-startify'
    use 'kyazdani42/nvim-tree.lua'
    use 'scrooloose/nerdcommenter'
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-surround'
    use 'ntpeters/vim-better-whitespace'
    use 'Yggdroot/indentLine'
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    use 'junegunn/fzf.vim'
    use 'junegunn/goyo.vim'
    use 'mfussenegger/nvim-dap'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- Completion
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'

    -- Status and tabs
    use 'itchyny/lightline.vim'

    -- Syntax
    use 'habamax/vim-godot'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Color schemes
    use { 'ParamagicDev/vim-medic_chalk', as = 'medic_chalk' }
end
