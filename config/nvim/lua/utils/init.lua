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
    vim.api.nvim_set_keymap(mode, keys, action, options)
end

for _, m in ipairs { 'c', 'i', 'n', 's', 't' } do
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

-- To create objects with functions that will be added to the global namespace
-- and has call_string() method that returns a string vim can use
local v_function_mt = {
    __call = function(self) self.action() end,
    __tostring = function(self) return self.name end,
}

-- create v_function object
utils.v_function = function(name, action)
    assert(type(name) == "string", "v_function name must be set")
    assert(type(action) == "function", "v_function action must be set")

    local v_func = {
        name = name,
        action = action,
    }
    setmetatable(v_func, v_function_mt)

    -- Add to global namespace
    _G[name] = v_func

    v_func.call_string = function(self)
        return string.format(":call v:lua.%s()", self.name)
    end
    v_func.v_string = function(self)
        return string.format("v:lua.%s()", self.name)
    end

    return v_func
end

local compile_au_string = function(event, pattern, action)
    -- try to compile multiple actions into one string
    local events = ''
    if type(event) == "table" then
        events = table.concat(event, ',')
    elseif type(event) == "string" then
        events = event
    end

    -- construct an action command accordingly
    local action_cmd = ''
    if type(action) == "table" or type(action) == "function" then
        assert(getmetatable(action) == v_function_mt, "action is not v_function object")
        action_cmd = action:call_string()
    else
        action_cmd = action
    end

    -- TODO: Option for silent and extra stuff?
    return string.format("autocmd %s %s %s", events, pattern or '', action_cmd)
end

-- Functions to create auto commands
-- args = {
--      event = Event name or a table of multiple events,
--      action = string -> vimscript command, v_function -> lua code
-- }
utils.autocmd = function(args)
    -- check if event and action not set
    assert(args.event, "Event name is not set")
    assert(args.action, "Action is not set")
    local au = compile_au_string(args.event, args.pattern, args.action)
    vim.api.nvim_command(au)
end

-- args = {
--      name = name of augroup
--      commands = table with the same arguments as autocmd
-- }
utils.augroup = function(args)
    assert(args.name, "Group name is not set")
    assert(args.commands, "Commands are not set")
    assert(#args.commands > 0, "Commands cannot be empty")
    local cmd = vim.api.nvim_command

    cmd("augroup " .. args.name)
    cmd("au!")

    for _, command in ipairs(args.commands) do
        if type(command) ~= "table" then break end
        utils.autocmd(command)
    end

    cmd("augroup END")
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
