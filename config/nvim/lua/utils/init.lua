local utils = {}

-- Options set functions
local scopes = {
    b = vim.bo,
    o = vim.o,
    w = vim.wo,
}

utils.set = function (scope, key, value)
    scopes[scope][key] = value
end

-- Format of options table
-- options = {
--      b, o, w = {
--          option = value,
--      },
-- }
utils.set_options = function (options)
    for scope, scope_options in pairs(options) do
        for option, value in pairs(scope_options) do
            utils.set(scope, option, value)
        end
    end
end

-- Keybinding functions
local map = function(mode, keys, action, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.keymap.set(mode, keys, action, options)
end

for _, m in ipairs { 'c', 'i', 'n', 's', 't', 'x' } do
    utils[m .. 'map'] = function(keys, action, opts) map(m, keys, action, opts) end
end

-- Helper function to write escape sequence to a pid
utils.esc_write = function(pid, sequence)
    if pid then
        local fd = io.open("/proc/" .. pid .. "/fd/0", 'w')
        io.output(fd)
        io.write(sequence)
        io.close()
    end
end

-- Functions to create auto commands
-- args = {
--      event = Event name or a table of multiple events,
--      action = string -> vimscript command, function -> lua code
-- }
utils.autocmd = function(args)
    assert(args.event, "Event name is not set")
    assert(args.action, "Action is not set")

    local event = args.event
    local opts = vim.tbl_extend('force', args, {
        callback = type(args.action) == "function" and args.action or nil,
        command = type(args.action) == "string" and args.action or nil,
    })

    opts.event = nil
    opts.action = nil

    vim.api.nvim_create_autocmd(event, opts)
end

-- args = {
--      name = name of augroup
--      commands = table with the same arguments as autocmd
-- }
utils.augroup = function(args)
    assert(args.name, "Group name is not set")
    assert(args.commands, "Commands are not set")
    assert(#args.commands > 0, "Commands cannot be empty")

    local id = vim.api.nvim_create_augroup(args.name, { clear = true })

    for _, command in ipairs(args.commands) do
        if type(command) ~= "table" then break end
        utils.autocmd(vim.tbl_extend('force', command, { group = id }))
    end
end

-- Helper function to source vimscript files
utils.source = function(file)
    local config_path = vim.fn.stdpath('config')
    vim.api.nvim_command(string.format("source %s/%s", config_path, file))
end

-- Color\Highlight related functions
utils.colorscheme = function(scheme)
    vim.api.nvim_command("colorscheme " .. scheme)
end

utils.get_highlight = function(group, attribute)
    local fn = vim.fn
    return fn.synIDattr(fn.hlID(group), attribute)
end

utils.set_highlight = function(group, attributes)
    local attrs = ''
    for k, v in pairs(attributes) do
        attrs = attrs .. string.format(' %s=%s', k, v)
    end
    vim.api.nvim_command('hi ' .. group .. attrs)
end

return utils
