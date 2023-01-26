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
    use {
        'windwp/nvim-autopairs', after = 'nvim-cmp',
        config = function ()
            require("nvim-autopairs").setup {}
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            require'cmp'.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' }}))
        end,
    }
    use {
        'abecodes/tabout.nvim',
        config = [[ require('tabout').setup {} ]],
        wants = 'nvim-treesitter',
        after = 'nvim-cmp',
    }
    use { 'tpope/vim-surround', event = 'InsertEnter' }
    use { 'ntpeters/vim-better-whitespace', event = 'BufWritePre *', config = 'vim.cmd[[EnableWhitespace]]' }
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
    --use {
        --'nvim-neorg/neorg', requires = 'nvim-lua/plenary.nvim',
        --config = [[ require('plugins.config.neorg') ]],
    --}
    use { 'nvim-neorg/neorg-telescope', requires = 'nvim-neorg/neorg' }

    -- Completion
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-cmp',
        config = [[ require('lsp') ]],
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' }, -- For capabilities
        },
        disable = not vim.g.lsp_imp == "native",
    }
    use { 'weilbith/nvim-code-action-menu', after = 'nvim-cmp', config = function() vim.g.code_action_menu_show_diff = false end}
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
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
    -- Snippets
    use { 'L3MON4D3/LuaSnip', after = 'nvim-cmp', config = [[ require('plugins.config.luasnip')]] }
    use {
        'rafamadriz/friendly-snippets',
        'Neevash/awesome-flutter-snippets',
    }
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
    use { 'nvim-treesitter/playground' }
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
    use 'lommix/godot.nvim'
    use 'stevearc/vim-arduino'
    use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}

    -- Color schemes
    use 'folke/tokyonight.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'savq/melange'
    use 'shaunsingh/nord.nvim'
    use 'daschw/leaf.nvim'
end
