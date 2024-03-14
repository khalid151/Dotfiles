local fn = vim.fn
local get_icon = require('nvim-web-devicons').get_icon

-- Tabline options
local empty_tab = '[No Name]'
local edit_status_icon = ' 󰷫'
local buffer_ignore_list = { 'NvimTree_' }

local current_tab = function(bufname, modified)
    local icon = get_icon(bufname)
    local filename = fn.fnamemodify(bufname, ':t')
    return string.format(" %s%s%s ",
        icon and icon .. ' ' or '',
        filename ~= '' and filename or empty_tab,
        modified == 1 and edit_status_icon or '')
end

-- Save last valid tab
local last_tab = {}

function LuaTabline()
    local tabline = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, '&mod')
        local tab = current_tab(bufname, bufmodified)

        -- Set an empty name if nvim was opened to a tab it should ignore
        if last_tab[index] == nil then
            last_tab[index] = string.format(' %s ' , empty_tab)
        end

        -- Check if the current tab is something that should be ignored
        local ignore_buffer = false
        for _, ignore in ipairs(buffer_ignore_list) do
            if string.find(tab, ignore) then
                ignore_buffer = true
                break
            end
        end

        if not ignore_buffer then
            last_tab[index] = tab
        end

        -- Construct the tabline
        tabline = tabline .. '%' .. index .. 'T'

        if index == fn.tabpagenr() then
            tabline = tabline .. '%#TabLineSel#'
            tabline = tabline .. last_tab[index]
        else
            tabline = tabline .. '%#TabLine#'
            if fn.tabpagenr() + 1 ~= index and index ~= 1 then
                tabline = tabline .. '|'
            end
            tabline = tabline .. string.format(" %d%s", index, last_tab[index])
        end
    end

    tabline = tabline .. '%#TabLineFill#'
    return tabline
end

vim.o.tabline = "%!v:lua.LuaTabline()"
