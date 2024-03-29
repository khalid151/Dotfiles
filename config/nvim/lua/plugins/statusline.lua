local lualine = require("lualine")

local theme = 'auto'

local active = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', file_status = true } },
    lualine_x = {
        { 'diagnostics', sources = {'nvim_diagnostic', 'coc'} },
        {
            function()
                local g = vim.g
                local board = g.arduino_board
                return " " .. board
            end,
            condition = function() return vim.fn.expand('%:e') == "ino" end,
        },
    },
    lualine_y = { 'filetype' },
    lualine_z = { { 'location', icon = '󰦨', cond = function() return not (vim.api.nvim_get_mode().mode == 't') end } },
}

local inactive = {
    lualine_a = { 'filetype' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
}

lualine.setup {
    options = {
        theme = theme,
        section_separators = { '', '' },
        component_separators = { '', '' },
    },
    sections = active,
    inactive_sections = inactive,
    extensions = { 'nvim-tree' },
}

vim.opt.laststatus = 3
