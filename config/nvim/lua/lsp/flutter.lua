require("flutter-tools").setup {
    outline = { open_cmd = '45vnew' },
    flutter_path = os.getenv("HOME") .. "/.local/share/flutter/bin/flutter",
}

local ok, telescope = pcall(require, "telescope")
if ok then
    telescope.load_extension("flutter")
    require'utils'.nmap('<Leader>fc', ":lua require('telescope').extensions.flutter.commands()<CR>", { silent = true })
end
