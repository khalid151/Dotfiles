local utils = require("utils")

local autocmd = utils.autocmd
local augroup = utils.augroup

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
        { event = 'InsertEnter', action = 'setlocal norelativenumber' },
        { event = 'InsertLeave', action = 'setlocal relativenumber' },
        { event = 'InsertLeave', pattern = '{}', action = 'setlocal norelativenumber' },
        { event = 'BufEnter', pattern = 'Flutter*Outline', action = 'setlocal nonumber norelativenumber' },
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
            action = function()
                if vim.g.terminal_bg then
                    local bg = utils.get_highlight("normal", "bg")
                    set_terminal_bg(bg)
                end
            end,
        },
        {
            event = 'VimLeave',
            pattern = '*',
            action = function()
                local bg = vim.g.terminal_bg
                if bg then set_terminal_bg(bg) end
            end,
        }
    },
}

-- Cursorline
augroup {
    name = 'curline',
    commands = {
        { event = 'WinEnter', action = 'setlocal cursorline' },
        { event = 'WinLeave', action = 'setlocal nocursorline' },
        { event = 'WinEnter', pattern = '{}', action = 'setlocal nocursorline' },
    },
}

-- Gitsigns color
autocmd {
    event = 'ColorScheme',
    pattern = '*',
    action = function()
        local bg = utils.get_highlight("SignColumn", "bg")
        bg = bg == '' and utils.get_highlight("normal", "bg") or bg
        for group, color in pairs {
                GitAdd = 'green',
                GitRemove = 'red',
                GitChange = 'blue',
            } do
            utils.set_highlight(group, { guifg = color, guibg = bg })
        end
    end,
}

-- Format dart on save
--autocmd {
    --event = 'BufWritePost',
    --pattern = '*.dart',
    --action = function ()
        --local file = vim.fn.bufname()
        --vim.fn.system('dart format ' .. file)
        --vim.api.nvim_command('e')
    --end,
--}
