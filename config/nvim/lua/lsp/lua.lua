local bin_path = "/usr/bin/lua-language-server"
local root_path = "/usr/share/lua-language-server"
local ok, capabilities = pcall(require, 'cmp_nvim_lsp')
capabilities = ok and capabilities.default_capabilities() or nil

require("lspconfig").sumneko_lua.setup {
    cmd = { bin_path, "-E", root_path .. "/main.lua" };
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
