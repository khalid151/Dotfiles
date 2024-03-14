local utils = require("utils")

-- Store PID of current shell, useful to change backgrounds
vim.g.shell_pid = vim.fn.system('ps -oppid= -p `ps -oppid= $$`')

vim.g.lsp_imp = "native"

-- Editor options
require("settings")

-- Configure keybindings
require("keymaps")

-- Load plugins and LSP
require("plugins")

-- User-defined commands and auto commands
utils.source("commands.vim")
require("autocmd")

-- Set theme
utils.colorscheme("nightfox")

-- Neovide options
if vim.g.neovide then
    vim.opt.linespace = 0
    vim.o.guifont = 'Iosevka Nerd Font:h12'
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    utils.map({'n', 'v'}, "<C-V>", '"+p')
    utils.cmap("<C-V>", '<C-R>+')
    utils.tmap("<C-V>", '<C-\\><C-n>"+pi')
end
