local tab_width = 4

require 'utils'.set_options {
    b = {
        expandtab = true,
        shiftwidth = tab_width,
        tabstop = tab_width,
    },
    o = {
        clipboard = 'unnamed,unnamedplus',
        completeopt= 'menuone,noselect',
        directory = '/dev/shm',
        expandtab = true,
        ignorecase = true,
        inccommand = 'split',
        mouse = 'a',
        pumheight = 10,
        shiftwidth = tab_width,
        shortmess = vim.o.shortmess .. 'c',
        showmode = false,
        smartcase = true,
        smartindent = true,
        splitright = true,
        tabstop = tab_width,
        termguicolors = true,
        title = true,
        updatetime = 100,
        laststatus = 3,
        showtabline = 2,
    },
    w = {
        cursorline = true,
        number = true,
        relativenumber = true,
        wrap = false,
    },
}
