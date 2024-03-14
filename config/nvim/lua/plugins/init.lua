-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Get a list of plugins and load them
local plugins_list = require("plugins.list")
require('lazy').setup(plugins_list)

-- Load plugin config
require("plugins.config")

-- Load tabline
require("plugins.tabline")
