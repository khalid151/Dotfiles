local utils = require("utils")

-- Store PID of current shell, useful to change backgrounds
vim.g.shell_pid = vim.fn.system('ps -oppid= -p `ps -oppid= $$`')

-- Editor options
require("settings")

-- Load plugins and LSP
require("plugins")
require("lsp")

-- Configure keybindings
require("keymaps")

-- User-defined commands and auto commands
utils.source("commands.vim")
require("autocmd")

-- Set theme
utils.colorscheme("medic_chalk")
