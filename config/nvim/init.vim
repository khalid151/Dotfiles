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
    Plug 'calviken/vim-gdscript3'

    " Others
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'vimwiki/vimwiki'
    Plug 'tpope/vim-surround'
    Plug 'majutsushi/tagbar'
    Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

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
" -----------------
" Auto commands
" -----------------
augroup auto
    au!
    autocmd VimLeave * set guicursor=a:ver25
    " terminal
    autocmd TermOpen * silent! setlocal nonumber norelativenumber nocursorline * resize - 15
    autocmd InsertEnter * silent! setlocal norelativenumber
    autocmd InsertLeave * silent! setlocal relativenumber
    " coc-flutter log - remove numbers
    autocmd BufEnter * if bufname() =~# ".*flutter-dev.*" | setlocal nonumber norelativenumber | endif
augroup END
" -----------------
"  Theme options
" -----------------
set background=dark
colorscheme wombat256grf
" Change terminal background to match theme
augroup theme
    au!
    " Change terminal bg according to theme bg
    autocmd VimEnter * silent! :call WriteEscapeSequence("\e]11;" . GetCurrentBG())
    autocmd VimLeave * silent! :call WriteEscapeSequence("\e]11;" . fnameescape(g:terminal_bg))
    autocmd ColorScheme * silent! :call WriteEscapeSequence("\e]11;" . GetCurrentBG())
augroup END
" -----------------
" Mappings
" -----------------
nmap <C-e> :NERDTreeToggle <CR>
nmap <C-t> :tabnew <CR>
nmap <Leader><Leader> :vsplit <CR>
nnoremap <Leader>` :belowright split term://zsh <CR>
nnoremap <Leader>pf <C-^>
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
nmap <silent><Leader>gd <Plug>(coc-definition)
nmap <silent><Leader>gr <Plug>(coc-references)
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR> pumvisible() ? (complete_info().selected == -1 ? "\<CR>" : "\<C-y>") : "\<CR>"
nnoremap <silent> <c-K> :call CocAction('doHover') <CR>
" coc-flutter
nnoremap <Leader>fc :CocList --input=flutter commands <CR>
" find files in path
set path+=**
nnoremap <Leader>ff :find<space>
" toggle Tagbar focus
nnoremap <silent><expr> <Leader>tg bufname() =~# '.Tagbar.' ? "\<C-w>\<C-p>" : ":TagbarOpen fj<CR>"
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
      \ 'colorscheme': 'wombat',
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
" -----------------
" Other stuff
" -----------------
let g:python3_host_prog = "/usr/bin/python"
let g:session_directory = "~/.config/nvim/session"
let g:shell_pid = substitute(system('ps -oppid= -p `ps -oppid= $$`'), '\n\| ', '', 'g')
