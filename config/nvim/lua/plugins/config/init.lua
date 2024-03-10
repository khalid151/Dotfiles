local g = vim.g -- global variables

g.AutoPairsMapSpace = 0
g.indent_blankline_show_current_context = true
g.indent_blankline_show_first_indent_level = false
g.indent_blankline_show_trailing_blankline_indent = false
g.strip_whitespace_on_save = 1
g.webdevicons_enable = 1
g.webdevicons_enable_ctrlp = 1
g.webdevicons_enable_ctrlp = 1
g.WebDevIconsUnicodeDecorateFolderNodes = 1
g.workspace_use_devicons = 1
g.tagbar_compact = 1
g.tagbar_autoclose = 0

-- Configure gitsigns
require 'gitsigns'.setup {
    signs = {
        add = { text = '+', hl = 'GitAdd' },
        change = { text = '~', hl = 'GitChange' },
        delete = { text = '-', hl = 'GitRemove' },
    },
}

for hl_group, color in pairs {
    GitAdd = 'green',
    GitRemove = 'red',
    GitChange = 'blue',
} do
    vim.api.nvim_command('hi '.. hl_group .. ' guifg=' .. color)
end

-- Treesitter
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true
    },
}

require("plugins.config.dashboard")
require("plugins.config.telescope")
