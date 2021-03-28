" -----------------
"  Plug-in manager
" -----------------
call plug#begin('~/.config/nvim/plugged')

    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/nerdcommenter'
    Plug 'mhinz/vim-startify'
    Plug 'jiangmiao/auto-pairs'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'Yggdroot/indentLine'
    Plug 'itchyny/lightline.vim'

    " Auto-complete stuff
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Syntax
    Plug 'dart-lang/dart-vim-plugin'
    Plug 'vim-syntastic/syntastic'
    Plug 'jelera/vim-javascript-syntax'
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'sheerun/vim-polyglot'
    Plug 'habamax/vim-godot'

    " Others
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'vimwiki/vimwiki'
    Plug 'tpope/vim-surround'
    Plug 'majutsushi/tagbar'
    Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
    Plug 'ParamagicDev/vim-medic_chalk', { 'as': 'medic_chalk' }
    Plug 'honza/vim-snippets'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'machakann/vim-highlightedyank'
    Plug 'godlygeek/tabular'

call plug#end()
" -----------------
" General options
" -----------------
set number
set relativenumber
set shiftwidth=4
set tabstop=4
set expandtab
set cursorline
set title
set nowrap
set noshowmode
set termguicolors
set ignorecase
set smartcase
set mouse=a
set clipboard+=unnamedplus
set directory=/dev/shm
set updatetime=100
set pumheight=10
set inccommand=split
" -----------------
" Auto commands
" -----------------
augroup auto
    au!
    autocmd VimLeave * set guicursor=a:ver25
    " handle line numbers change
    autocmd TermOpen * silent! setlocal nonumber norelativenumber nocursorline * resize - 15
    autocmd InsertEnter * silent! setlocal norelativenumber
    autocmd InsertLeave * silent! setlocal relativenumber
    autocmd BufEnter * if bufname() =~# ".*flutter-dev.*" | setlocal nonumber norelativenumber | endif
augroup END
" -----------------
"  Theme options
" -----------------
set background=dark
colorscheme medic_chalk
" Change terminal background to match theme
augroup theme
    au!
    autocmd VimEnter * if exists("g:terminal_bg") | silent! :call WriteEscapeSequence("\e]11;" . GetCurrentBG()) | endif
    autocmd VimLeave * silent! :call WriteEscapeSequence("\e]11;" . fnameescape(g:terminal_bg))
    autocmd ColorScheme * if exists("g:terminal_bg") | silent! :call WriteEscapeSequence("\e]11;" . GetCurrentBG()) | endif
augroup END
" -----------------
" Mappings
" -----------------
nmap <C-e> :NERDTreeToggle <CR>
nmap <C-t> :tabnew <CR>
nmap <Leader><Leader> :vsplit <CR>
nnoremap <Leader>` :belowright split term://zsh <CR>
nnoremap <Leader>pf <C-^>
nnoremap <Leader>rg :Grep<space>
" Alt + h,j,k,l window movement
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" window resize
nnoremap <silent> <A-C-j> :resize +5 <CR>
nnoremap <silent> <A-C-k> :resize -5 <CR>
nnoremap <silent> <A-C-l> :vert res +5 <CR>
nnoremap <silent> <A-C-h> :vert res -5 <CR>
" coc
nmap <silent> <leader>a <Plug>(coc-codeaction-line)
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent><Leader>gd <Plug>(coc-definition)
nmap <silent><Leader>gr <Plug>(coc-references)
nmap <silent><Leader>gi <Plug>(coc-implementation)
nmap <silent><Leader>gy <Plug>(coc-type-definition)
nmap <silent><Leader>rn <Plug>(coc-rename)
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR> complete_info().selected != -1 ?
            \ &filetype == "gdscript" ? (coc#expandable() ?  "\<C-y>" : "\<Esc>a") : "\<C-y>"
            \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> <c-K> :call CocAction('doHover') <CR>
" coc-flutter
nnoremap <Leader>fc :CocList --input=flutter commands <CR>
nnoremap <Leader>fr :CocCommand flutter.dev.hotReload <CR>
nnoremap <Leader>fR :CocCommand flutter.dev.hotRestart <CR>
" find files in path
nnoremap <Leader>ff :Files <CR>
" toggle Tagbar focus
nnoremap <silent><expr> <Leader>tg bufname() =~# '.Tagbar.' ? "\<C-w>\<C-p>" : ":TagbarOpen fj<CR>"
" goyo
nnoremap <silent> <Leader>z :Goyo <CR>
" -----------------
" Plug-in settings
" -----------------
" devIcons
let g:webdevicons_enable = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_ctrlp = 1
let g:workspace_use_devicons = 1
" NERDTree
let g:NERDTreeMouseMode = 1
let g:NERDTreeMinimalUI = 1
" Whitespaces
let g:strip_whitespace_on_save = 1
" Lightline
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \  'left': [['mode', 'paste'],
      \           ['readonly', 'filename', 'modified']],
      \  'right': [['filetype'],
      \            ['percent', 'lineinfo'],
      \            ['coc_status']]
      \ },
      \ 'component_function': {
      \ 'coc_status': 'coc#status',
      \ 'filetype': 'Filetype',
      \ 'fileformat': 'Fileformat',
      \ }
      \ }
let g:lightline.tab = {
    \'active': [ 'filename', 'modified' ]
\}
let g:lightline.component = { 'close': '%999X  ' }
" tagbar
let g:tagbar_compact = 1
let g:tagbar_autoclose = 0
" indentLine
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = [''] " To exclude it on terminal buffer
" fzf
let g:fzf_preview_window = 'right:60%'
" goyo
let g:goyo_linenr = 1
" autopairs
let g:AutoPairsMapSpace = 0
" -----------------
" Functions
" -----------------
function! Filetype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! Fileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function GetCurrentBG()
    return fnameescape(synIDattr(hlID("normal"), "bg"))
endfunction

function WriteEscapeSequence(seq)
    let shell_fd = '/proc/' . g:shell_pid . '/fd/0'
    let command = '!printf "' . a:seq . '\007" >' . shell_fd
    exe command
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

function! ProcessRgFzf(line)
    " line = FILE : COL : ROW : WORD
    let l:info = split(a:line, ":")
    execute "edit " .. l:info[0]
    call cursor(l:info[1], l:info[2])
    call feedkeys("*``", "n")
endfunction
" -----------------
" Commands
" -----------------
command! -nargs=1 Uvicorn call UvicornRun(substitute(bufname(), '.py', '', ''), '<args>')
command! -bang -nargs=* Grep
  \ call fzf#vim#grep(
  \   'rg -o -p --column --no-heading -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'sink': function('ProcessRgFzf')}), <bang>0)
" -----------------
" Other stuff
" -----------------
let g:python3_host_prog = "/usr/bin/python"
let g:session_directory = "~/.config/nvim/session"
let g:shell_pid = substitute(system('ps -oppid= -p `ps -oppid= $$`'), '\n\| ', '', 'g')
