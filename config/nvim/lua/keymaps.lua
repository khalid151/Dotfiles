local utils = require("utils")

local cmap = utils.cmap
local imap = utils.imap
local nmap = utils.nmap
local smap = utils.smap
local tmap = utils.tmap
local xmap = utils.xmap

local t = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

-- General
imap('<C-l>', '<Esc>A')

-- Toggle explorer
nmap('<C-b>', 'bufname() =~# "NvimTree" ? ":NvimTreeClose<CR>" : ":NvimTreeFocus<CR>"', { expr = true, silent = true })

-- New tab
nmap('<C-t>', ':tabnew<CR>', { silent = true })

-- Split current file view
nmap('<Leader><Leader>', ':vsplit<CR>', { silent = true })

-- Open terminal (floating terminal toggle)
nmap('<Leader>`', ':lua require"FTerm".toggle()<CR>', { silent = true })
tmap('<Leader>`', '<C-\\><C-N>:lua require"FTerm".toggle()<CR>', { silent = true })

-- Previous file toggle
nmap('<Leader>pf', '<C-^>')

-- Command mode navigation
cmap('<C-j>', '<down>')
cmap('<C-k>', '<up>')
cmap('<C-h>', '<left>')
cmap('<C-l>', '<right>')

-- Clear first search highlight
local clear_search = function()
  local cmd = vim.fn.getcmdtype()
  if cmd == "/" or cmd == "?" then
    return t("<CR> :noh<CR>b")
  end

  return t("<CR>")
end

cmap('<CR>', clear_search, { silent = true, expr = true, noremap = true })

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

-- Fuzzy finder
nmap('<Leader>ff', ':Telescope find_files<CR>', { silent = true })
nmap('<Leader>rg', ':Grep<space>')

-- Tagbar
nmap('<Leader>tg', 'bufname() =~# ".Tagbar." ? "\\<C-w>\\<C-p>" : ":TagbarOpen fj<CR>"', { expr = true, silent = true })

-- Gitsigns
nmap(']c', ':Gitsigns next_hunk<CR>', { silent = true })
nmap('[c', ':Gitsigns prev_hunk<CR>', { silent = true })

-- Todo
nmap('<Leader>td', ':TodoQuickFix<CR>', { silent = true })

-- LSP
nmap('<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true })
nmap('<Leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true })
nmap('<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true })
nmap('<Leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true })
nmap('<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true })
nmap('<C-k>',  '<cmd>lua vim.lsp.buf.signature_help()<CR>', { silent = true })
nmap('<C-n>', '<cmd>lua vim.diagnostic.goto_next()<CR>', { silent = true })
nmap('<C-p>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { silent = true })
nmap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { silent = true })
nmap('<Leader>ga', "<cmd>CodeActionMenu<CR>", { silent = true })
xmap('<Leader>ga', "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })

-- DAP
nmap('<Leader>dd', ':DapToggleBreakpoint<CR>', { silent = true })
nmap('<Leader>dc', ':DapContinue<CR>', { silent = true })
nmap('<Leader>di', ':DapStepInto<CR>', { silent = true })
nmap('<Leader>do', ':DapStepOver<CR>', { silent = true })
nmap('<Leader>dO', ':DapStepOut<CR>', { silent = true })
nmap('<Leader>dt', ':DapUiToggle<CR>', { silent = true})
