return function(use)
    -- Manage packer
    use 'wbthomason/packer.nvim'

    -- General
    use 'scrooloose/nerdcommenter'
    use 'Yggdroot/indentLine'
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    use 'mfussenegger/nvim-dap'
    use 'numtostr/FTerm.nvim'
    use 'glepnir/dashboard-nvim'
    use { 'windwp/nvim-autopairs', event = 'InsertEnter', config = [[require('nvim-autopairs').setup{}]] }
    use { 'tpope/vim-surround', event = 'InsertEnter' }
    use { 'ntpeters/vim-better-whitespace', event = 'BufWritePre *', config = 'vim.cmd[[EnableWhitespace]]' }
    use { 'junegunn/goyo.vim', ft = {'text', 'markdown'} }
    use { 'preservim/tagbar', ft = {'c', 'cpp'} }
    use { 'kyazdani42/nvim-tree.lua', config = function()
        require'nvim-tree'.setup {
            update_cwd = true,
            filters = {
                dotfiles = true,
            }
        }
        end
    }
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
        }
    }
    use {
        'nvim-neorg/neorg', requires = 'nvim-lua/plenary.nvim',
        config = [[ require('plugins.config.neorg') ]],
    }
    use { 'nvim-neorg/neorg-telescope', requires = 'nvim-neorg/neorg' }

    -- Completion
    use {
        'neovim/nvim-lspconfig',
        config = [[ require('lsp') ]],
        disable = not vim.g.lsp_imp == "native",
    }
    use {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = [[ require('plugins.config.cmp') ]],
        disable = not vim.g.lsp_imp == "native",
    }
    use {
        'onsails/lspkind-nvim',
        after = 'nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local fmt = require('lspkind').cmp_format
            cmp.setup {
                formatting = {
                    format = fmt {}
                }
            }
        end,
    }
    use {
        'ray-x/lsp_signature.nvim',
        after = 'nvim-cmp',
        config = [[ require('lsp_signature').setup { doc_lines = 0, hint_enable = false } ]],
    }
    -- Completion sources
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' }
    -- Snippets
    use { 'hrsh7th/vim-vsnip', after = 'nvim-cmp' }
    use {
        'rafamadriz/friendly-snippets',
        'Neevash/awesome-flutter-snippets',
    }
    --use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
        'neoclide/coc.nvim', branch = 'release',
        disable = vim.g.lsp_imp == "native",
    }
    use { 'honza/vim-snippets', after = 'coc.nvim' }

    -- Status and tabs
    use { 'hoob3rt/lualine.nvim', config = function() require'plugins.statusline' end }

    -- Syntax
    use { 'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
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

    -- Language specific
    use 'habamax/vim-godot'
    use 'stevearc/vim-arduino'
    use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}

    -- Color schemes
    use 'ParamagicDev/vim-medic_chalk'
    use 'gryf/wombat256grf'
    use 'folke/tokyonight.nvim'
end
