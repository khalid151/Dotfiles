local theme = require('utils').lazy_theme

return {
    -- Colors
    theme 'EdenEast/nightfox.nvim',

    -- No lazy :c
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons',
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

    -- Completion, Highlights & Code
    { 'neovim/nvim-lspconfig', config = function() require 'lsp' end }, -- event = { 'BufReadPost', 'BufNewFile' }, cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' }},
    { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {}, cmd = {'TodoQuickFix', 'TodoLocList', 'TodoTelescope', 'TodoTrouble'}},
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'kylechui/nvim-surround', event = { 'InsertEnter', 'VeryLazy' }, opts = {} },
    { 'ntpeters/vim-better-whitespace', event = 'BufWritePre *', config = function() vim.cmd[[EnableWhitespace]] end },
    { 'akinsho/flutter-tools.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, ft = 'dart'},
    { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu', config = function() vim.g.code_action_menu_show_diff = false end},
    {
        'ray-x/lsp_signature.nvim',
        event = 'InsertEnter',
        config = function(_, opts) require 'lsp_signature'.on_attach(opts) end,
        opts = { hint_prefix = ' ' },
    },
    {
        'numToStr/Comment.nvim', config = function() require('plugins.config.comment') end,
        event = 'InsertEnter',
        keys = {
            '<Leader>cc',
            { '<Leader>c', mode = 'v' },
        },
    },
    {
        'L3MON4D3/LuaSnip', config = function() require'plugins.config.luasnip' end,
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/nvim-cmp',
            'rafamadriz/friendly-snippets',
            'Neevash/awesome-flutter-snippets',
        },
    },
    {
        'hrsh7th/nvim-cmp', event = 'InsertEnter',
        config = function() require 'plugins.config.cmp' end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
        },
    },
    {
        'onsails/lspkind-nvim',
        event = 'InsertEnter',
        config = function()
            local cmp = require('cmp')
            local fmt = require('lspkind').cmp_format
            cmp.setup {
                formatting = {
                    format = fmt {}
                }
            }
        end,
    },
    {
        'windwp/nvim-autopairs', dependencies = { 'hrsh7th/nvim-cmp' },
        event = 'InsertEnter',
        config = function ()
            require("nvim-autopairs").setup {}
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            require'cmp'.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' }}))
        end,
    },

    -- Misc
    { 'hoob3rt/lualine.nvim', config = function() require'plugins.statusline' end },
    { 'numtostr/FTerm.nvim', ft = 'FTerm' },
    { 'kyazdani42/nvim-tree.lua',
        cmd = 'NvimTreeFocus',
        config = function()
            require'nvim-tree'.setup {
                update_cwd = true,
                filters = {
                    dotfiles = true,
                }
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzy-native.nvim',
        }
    },
    {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        require("which-key").setup {
            icons = {
                separator = '>',
            }
        }
      end
    },
}
