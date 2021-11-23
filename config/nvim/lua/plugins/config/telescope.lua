local actions = require("telescope.actions")
require 'telescope'.setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--only-matching',
            '--column',
            '--no-heading',
            '--smart-case',
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
        },
    },
}
require 'telescope'.load_extension('fzy_native')
