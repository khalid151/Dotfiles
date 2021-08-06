" Helper functions

lua << EOF
_G.TelescopeGrep = function(word)
    require 'telescope.builtin'.grep_string {
        attach_mappings = function()
            local actions_set = require("telescope.actions.set")
            actions_set.select:enhance {
                post = function()
                    vim.fn.feedkeys("*``", "n")
                end,
            }
            return true
        end,
        search = word,
        use_regex = true,
        prompt_title = 'Grep',
    }
end
EOF

function! UvicornRun(filename, appname)
    let term = 'term uvicorn ' . a:filename . ':' . a:appname
    augroup uvicorn_term
        au!
        au TermClose * if bufname() =~# 'term.*:uvicorn' |
                    \ call nvim_input('<CR>')
                    \ | endif
        au TermOpen,BufEnter * if bufname() =~# 'term.*:uvicorn' |
                    \ setlocal statusline=\ >\ uvicorn
                    \ | startinsert
                    \ | endif
    augroup END
    exe 'belowright 10split |' . term
endfunction

" --------
" Commands
" --------
"  Uvicorn
command! -nargs=1 Uvicorn call UvicornRun(substitute(bufname(), '.py', '', ''), '<args>')
command! -nargs=1 Grep lua TelescopeGrep([[<args>]])
