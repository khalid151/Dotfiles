require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    neorg = "~/Documents/Neorg/",
                },
            },
        },
        ["core.gtd.base"] = {
            config = {
                workspace = "gtd",
                default_lists = {
                    inbox = "inbox.norg",
                },
            },
        },
        ["core.integrations.telescope"] = {},
    },
}
