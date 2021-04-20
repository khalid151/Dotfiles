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
    use 'junegunn/goyo.vim'
    use 'preservim/tagbar'
    use 'mfussenegger/nvim-dap'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
        }
    }

    -- Completion
    use 'neovim/nvim-lspconfig'
    use 'hrsh2th/nvim-compe'

    -- Status and tabs
    use 'itchyny/lightline.vim'

    -- Syntax
    use 'habamax/vim-godot'
    use { 'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end }
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {
        'sheerun/vim-polyglot',
        setup = function()
            -- Disable languages that are handled by TS
            vim.g.polyglot_disabled = {
                "c",
                "cpp",
                "dart",
                "gdscript",
                "lua",
                "python",
            }
        end,
    }
    -- Color schemes
    use 'ParamagicDev/vim-medic_chalk'
    use 'gryf/wombat256grf'
end
