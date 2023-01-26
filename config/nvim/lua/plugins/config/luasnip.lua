local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

local t = function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

local function jump_snippet(direction, fallback)
    local go = { next = 1, prev = -1 }
    if luasnip.jumpable(go[direction]) then
      luasnip.jump(go[direction])
    else
      vim.api.nvim_feedkeys(t(fallback), "n", false)
    end
end

vim.keymap.set({ 'i', 's' }, "<C-j>", function() jump_snippet("next", "<C-j>") end)
vim.keymap.set({ 'i', 's' }, "<C-k>", function() jump_snippet("prev", "<C-k>") end)
