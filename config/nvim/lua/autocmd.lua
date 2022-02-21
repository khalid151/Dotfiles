local utils = require("utils")

local autocmd = utils.autocmd
local augroup = utils.augroup
local v_function = utils.v_function

-- Highlight on yank
autocmd {
    event = 'TextYankPost',
    pattern = '*',
    action = 'lua vim.highlight.on_yank {on_visual = false, timeout = 500}',
}

-- Revert cursor on leave
autocmd { event = 'VimLeave', action = 'set guicursor=a:ver25' }

-- Line numbers
augroup {
    name = 'nums',
    commands = {
        { event = 'InsertEnter', pattern = '*', action = 'setlocal norelativenumber' },
        { event = 'InsertLeave', pattern = '*', action = 'setlocal relativenumber' },
        { event = 'InsertLeave', pattern = '{}', action = 'setlocal norelativenumber' },
        { event = 'TermOpen', pattern = '*', action = 'setlocal nonumber norelativenumber nocursorline' },
    },
}

-- Theme change
local set_terminal_bg = function(color)
    assert(vim.g.shell_pid, "g:shell_pid is not set")
    utils.esc_write(vim.g.shell_pid, "\x1b]11;" .. color .. "\007")
end

augroup {
    name = 'theme',
    commands = {
        {
            event = { 'VimEnter', 'ColorScheme' },
            pattern = '*',
            action = v_function('_set_term_bg', function()
                if vim.g.terminal_bg then
                    local bg = utils.get_highlight("normal", "bg")
                    set_terminal_bg(bg)
                end
            end),
        },
        {
            event = 'VimLeave',
            pattern = '*',
            action = v_function('_restore_term_bg', function()
                local bg = vim.g.terminal_bg
                if bg then set_terminal_bg(bg) end
            end),
        }
    },
}

-- Gitsigns color
autocmd {
    event = 'ColorScheme',
    pattern = '*',
    action = v_function('_change_signs_color', function()
        local bg = utils.get_highlight("SignColumn", "bg")
        bg = bg == '' and utils.get_highlight("normal", "bg") or bg
        for group, color in pairs {
                GitAdd = 'green',
                GitRemove = 'red',
                GitChange = 'blue',
            } do
            utils.set_highlight(group, { guifg = color, guibg = bg })
        end
    end),
}
