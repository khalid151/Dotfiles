local g = vim.g -- global variables

g.AutoPairsMapSpace = 0
g.WebDevIconsUnicodeDecorateFolderNodes = 1
g.fzf_preview_window = 'right:60%'
g.goyo_linenr = 1
g.indentLine_char = '│'
g.indentLine_fileTypeExclude = {''}
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_ignore = { '.git' }
g.strip_whitespace_on_save = 1
g.webdevicons_enable = 1
g.webdevicons_enable_ctrlp = 1
g.webdevicons_enable_ctrlp = 1
g.workspace_use_devicons = 1

-- Ultisnips disable mappings
g.UltiSnipsExpandTrigger = "<NUL>"
g.UltiSnipsJumpForwardTrigger = "<NUL>"
g.UltiSnipsJumpBackwardTrigger = "<NUL>"

-- Compe config
require 'compe'.setup {
    throttle_time = 20;

    source = {
        path = true;
        buffer = true;
        calc = false;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = false;
    };
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

-- Startify add icons
vim.api.nvim_exec(
[[
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
]], true)