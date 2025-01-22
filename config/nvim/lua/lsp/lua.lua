-- local bin_path = "/usr/bin/lua-language-server"
-- local root_path = "/usr/share/lua-language-server"
-- local ok, capabilities = pcall(require, 'cmp_nvim_lsp')
-- capabilities = ok and capabilities.default_capabilities() or nil
--
-- require("lspconfig").sumneko_lua.setup {
--     cmd = { bin_path, "-E", root_path .. "/main.lua" };
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = {
--                 version = 'LuaJIT',
--                 path = vim.split(package.path, ';'),
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = {'vim'},
--             },
--             workspace = {
--                 library = {
--                     [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--                     [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
--                 },
--             },
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }
--

require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
