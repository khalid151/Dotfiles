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

    " Others
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'connorholyday/vim-snazzy'
    Plug 'vimwiki/vimwiki'
    Plug 'nightsense/snow'

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

autocmd VimLeave * set guicursor=a:ver25
" Terminal
autocmd TermOpen * silent! setlocal nonumber norelativenumber nocursorline * resize - 15
autocmd InsertEnter * silent! setlocal norelativenumber
autocmd InsertLeave * silent! setlocal relativenumber
" -----------------
"  Theme options
" -----------------
set background=dark
colorscheme snow
" Change terminal background to match theme
autocmd VimEnter * silent! exe '!printf "\e]11;'.fnameescape(synIDattr(hlID("normal"), "bg")).'\007" > /proc/'.g:ZSH_PID.'/fd/0'
autocmd VimLeave * silent! exe '!printf "\e]11;'.fnameescape(g:TERMBG).'\007" > /proc/'.g:ZSH_PID.'/fd/0'
autocmd ColorScheme * silent! exe '!printf "\e]11;'.fnameescape(synIDattr(hlID("normal"), "bg")).'\007" > /proc/'.g:ZSH_PID.'/fd/0'
" -----------------
" Mappings
" -----------------
nmap <C-e> :NERDTreeToggle <CR>
nmap <C-t> :tabnew <CR>
nmap <Leader><Leader> :vsplit <CR>
nmap <C-b> :belowright split term://zsh <CR>
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
" coc
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> <c-K> :call CocAction('doHover') <CR>
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
      \ 'colorscheme': 'snazzy',
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
" -----------------
" Custom functions
" -----------------
function! Filetype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! Fileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
" -----------------
" Other stuff
" -----------------
let g:session_directory = "~/.config/nvim/session"
