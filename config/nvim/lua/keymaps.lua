local utils = require("utils")

local cmap = utils.cmap
local imap = utils.imap
local nmap = utils.nmap
local tmap = utils.tmap

-- Toggle explorer
nmap('<C-e>', ':NvimTreeToggle<CR>', { silent = true })

-- New tab
nmap('<C-t>', ':tabnew<CR>', { silent = true })

-- Split current file view
nmap('<Leader><Leader>', ':vsplit<CR>', { silent = true })

-- Open terminal
nmap('<Leader>`', ':belowright split term://zsh<CR>', { silent = true })

-- Previous file toggle
nmap('<Leader>pf', '<C-^>')

-- Command mode navigation
cmap('<C-j>', '<down>')
cmap('<C-k>', '<up>')
cmap('<C-h>', '<left>')
cmap('<C-l>', '<right>')

-- Alt + h,j,k,l window movement
tmap('<A-h>', '<C-\\><C-N><C-w>h')
tmap('<A-j>', '<C-\\><C-N><C-w>j')
tmap('<A-k>', '<C-\\><C-N><C-w>k')
tmap('<A-l>', '<C-\\><C-N><C-w>l')
imap('<A-h>', '<C-\\><C-N><C-w>h')
imap('<A-j>', '<C-\\><C-N><C-w>j')
imap('<A-k>', '<C-\\><C-N><C-w>k')
imap('<A-l>', '<C-\\><C-N><C-w>l')
nmap('<A-h>', '<C-w>h')
nmap('<A-j>', '<C-w>j')
nmap('<A-k>', '<C-w>k')
nmap('<A-l>', '<C-w>l')

-- Window resize
nmap('<A-C-j>', ':resize +5 <CR>', { silent = true })
nmap('<A-C-k>', ':resize -5 <CR>', { silent = true })
nmap('<A-C-l>', ':vert res +5 <CR>', { silent = true })
nmap('<A-C-h>', ':vert res -5 <CR>', { silent = true })

-- Fzf
nmap('<Leader>ff', ':Files<CR>', { silent = true })
nmap('<Leader>rg', ':Grep<space>')

-- Goyo
nmap('<Leader>z', ':Goyo<CR>', { silent = true })

-- Completion
imap('<C-Space>', 'compe#complete()', { expr = true, silent = true })
imap('<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
imap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', { expr = true, silent = true })
imap('<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, silent = true })
imap('<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, silent = true })
imap('<CR>', 'compe#confirm("<CR>")', { expr = true, silent = true })
imap('<C-e>', 'compe#close("<C-e>")', { expr = true, silent = true })
imap('<Esc>', 'pumvisible() ? compe#close("\\<C-e>") : "\\<Esc>"', { expr = true, silent = true })

nmap('<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true })
nmap('<Leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true })
nmap('<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true })
nmap('<Leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true })
nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true })
nmap('<C-k>',  '<cmd>lua vim.lsp.buf.signature_help()<CR>', { silent = true })
nmap('<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { silent = true })
nmap('<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { silent = true })