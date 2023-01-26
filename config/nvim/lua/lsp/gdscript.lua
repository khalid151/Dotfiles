local ok, capabilities = pcall(require, 'cmp_nvim_lsp')
capabilities = ok and capabilities.default_capabilities() or nil

require("lspconfig").gdscript.setup {
    capabilities = capabilities,
}
