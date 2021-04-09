" Helper functions
function! ProcessRgFzf(line)
    " line = FILE : COL : ROW : WORD
    let l:info = split(a:line, ":")
    execute "edit " .. l:info[0]
    call cursor(l:info[1], l:info[2])
    call feedkeys("*``", "n")
endfunction

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
" Grep, using rg command and displaying it in FZF window
command! -bang -nargs=* Grep
  \ call fzf#vim#grep(
  \   'rg -o -p --column --no-heading -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'sink': function('ProcessRgFzf')}), <bang>0)
