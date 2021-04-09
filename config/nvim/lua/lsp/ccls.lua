-- TODO: make it more automatic?
require("lspconfig").ccls.setup {
    init_options = {
        cache = {
            directory = "/tmp/ccls",
        }
    },
}
