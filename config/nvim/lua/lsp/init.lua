-- TODO: add checks for installed language servers?
-- Load LSP configs
require("lsp.ccls")
require("lsp.dart")
require("lsp.lua")
require("lsp.python")

-- Configure item icons
local item_kind = require("vim.lsp.protocol").CompletionItemKind
local set_icon = function(field, icon)
    item_kind[item_kind[field]] = icon .. ' ' .. field
end

set_icon('Class', '')
set_icon('Color', '')
--set_icon('Constant', '')
set_icon('Constant', '')
set_icon('Constructor', '')
set_icon('Enum', '')
set_icon('EnumMember', '')
set_icon('Event', '鬒')
set_icon('Field', '綠')
--set_icon('File', '')
set_icon('File', '')
set_icon('Folder', '')
set_icon('Function', '')
set_icon('Interface', '禍')
--set_icon('Keyword', '')
set_icon('Keyword', '')
set_icon('Method', '')
set_icon('Module', '')
set_icon('Operator', '洛')
set_icon('Property', '襁')
set_icon('Reference', '')
--set_icon('Snippet', '')
set_icon('Snippet', '﬌')
set_icon('Struct', '')
set_icon('Text', '')
set_icon('TypeParameter', '')
set_icon('Unit', '')
--set_icon('Value', '')
set_icon('Value', '')
set_icon('Variable', '')
