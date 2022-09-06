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
                workspace = "neorg",
                default_lists = {
                    inbox = "GTD/inbox.norg",
                },
            },
        },
        ["core.integrations.telescope"] = {},
    },
}
