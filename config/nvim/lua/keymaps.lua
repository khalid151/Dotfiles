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
_G._clear_search = function()
  local cmd = vim.fn.getcmdtype()
  if cmd == "/" or cmd == "?" then
    return t("<CR> :noh<CR>b")
  end

  return t("<CR>")
end

cmap('<CR>', 'v:lua._clear_search()', { silent = true, expr = true, noremap = true })

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

-- Completion
imap('<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
imap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', { expr = true, silent = true })

if vim.g.lsp_imp == "native" then
  _G._item_selection = function (direction, fallback)
    local vsnip_dir = { next = {1}, prev = {-1} }
    local cmp = require("cmp")
    if cmp.visible() then
      return t(string.format("<C-%s>", direction:sub(1, 1)))
    elseif vim.fn.call("vsnip#jumpable", vsnip_dir[direction]) == 1 then
      return t(string.format("<Plug>(vsnip-jump-%s)", direction))
    else
      return t(fallback)
    end
  end

  imap('<C-j>', 'v:lua._item_selection("next", "<C-j>")', { expr = true, noremap = false })
  imap('<C-k>', 'v:lua._item_selection("prev", "<C-k>")', { expr = true, noremap = false })
  smap('<C-j>', 'v:lua._item_selection("next", "<C-j>")', { expr = true, noremap = false })
  smap('<C-k>', 'v:lua._item_selection("prev", "<C-k>")', { expr = true, noremap = false })

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
else
  -- coc.nvim
  nmap('<Leader>a', '<Plug>(coc-codeaction-line)', { noremap = false, silent = true })
  xmap('<Leader>a', '<Plug>(coc-codeaction-selected)', { noremap = false, silent = true })

  imap('<C-Space>', 'coc#refresh()', { expr = true, silent = true })
  imap('<Esc>', [[pumvisible() ? "\<C-e>" : "\<Esc>"]], { expr = true, silent = true })
  imap('<CR>', [[ complete_info().selected != -1 ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  ]], { expr = true, silent = true })

  nmap('<Leader>gd', '<Plug>(coc-definition)', { noremap = false, silent = true })
  nmap('<Leader>gD', '<Plug>(coc-declaration)', { noremap = false, silent = true })
  nmap('<Leader>gr', '<Plug>(coc-references)', { noremap = false, silent = true })
  nmap('<Leader>gi', '<Plug>(coc-implementation)', { noremap = false, silent = true })
  nmap('<Leader>gy', '<Plug>(coc-type-definition)', { noremap = false, silent = true })
  nmap('<Leader>rn', '<Plug>(coc-rename)', { noremap = false, silent = true })
  nmap('K', ':call CocAction("doHover")<CR>', { silent = true })
  nmap('<C-n>', '<Plug>(coc-diagnostic-next)', { noremap = false, silent = true })
  nmap('<C-p>', '<Plug>(coc-diagnostic-prev)', { noremap = false, silent = true })
  nmap('<space>e', '<Plug>(coc-diagnostic-info)', { noremap = false, silent = true })
end
