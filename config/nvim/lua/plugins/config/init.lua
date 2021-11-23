local g = vim.g -- global variables

g.AutoPairsMapSpace = 0
g.WebDevIconsUnicodeDecorateFolderNodes = 1
g.indentLine_char = '│'
g.indentLine_fileTypeExclude = {''}
g.strip_whitespace_on_save = 1
g.webdevicons_enable = 1
g.webdevicons_enable_ctrlp = 1
g.webdevicons_enable_ctrlp = 1
g.workspace_use_devicons = 1
g.tagbar_compact = 1
g.tagbar_autoclose = 0

-- Vsnip
g.vsnip_filetypes = {
    arduino = { 'cpp' },
}

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
