local fn = vim.fn
local get_icon = require('nvim-web-devicons').get_icon

local current_tab = function(bufname, modified)
    local icon = get_icon(bufname)
    local filename = fn.fnamemodify(bufname, ':t')
    return string.format(" %s%s%s ",
        icon and icon .. ' ' or '',
        filename ~= '' and filename or '[No Name]',
        modified == 1 and '*' or '')
end

function LuaTabline()
    local tabline = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, '&mod')
        local tab = current_tab(bufname, bufmodified)

        tabline = tabline .. '%' .. index .. 'T'

        if index == fn.tabpagenr() then
            tabline = tabline .. '%#TabLineSel#'
            tabline = tabline .. tab
        else
            tabline = tabline .. '%#TabLine#'
            if fn.tabpagenr() + 1 ~= index and index ~= 1 then
                tabline = tabline .. '|'
            end
            tabline = tabline .. string.format(" %d%s", index, tab)
        end
    end

    tabline = tabline .. '%#TabLineFill#'
    return tabline
end

vim.o.tabline = "%!v:lua.LuaTabline()"
