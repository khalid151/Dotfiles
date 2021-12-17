-- Bootstrap packer
local fn = vim.fn
local cmd = vim.api.nvim_command
local utils = require("utils")

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    cmd [[!git clone https://github.com/wbthomason/packer.nvim " .. install_path]]
    cmd [[packadd packer.nvim]]
end

-- Reload plugins when plugins list gets updated
utils.autocmd {
    event = "BufWritePost",
    pattern = "*/plugins/list.lua",
    action = utils.v_function("_reload_plugins", function()
        -- unload plugins since they were cached
        package.loaded["plugins"] = nil
        package.loaded["plugins.list"] = nil
        -- reload and compile
        require("plugins").compile()
    end),
}

-- Load plugins
local plugins_list = require("plugins.list")
local packer = require("packer").startup(plugins_list)

-- Load plugin config
require("plugins.config")

-- Load tabline
require("plugins.tabline")

return packer
