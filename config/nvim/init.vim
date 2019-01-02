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
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/echodoc.vim'
    Plug 'zchee/deoplete-jedi' " Python auto-complete
    Plug 'zchee/deoplete-clang'
    Plug 'Shougo/neoinclude.vim'

    " Syntax
    Plug 'dart-lang/dart-vim-plugin'
    Plug 'vim-syntastic/syntastic'
    Plug 'jelera/vim-javascript-syntax'
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'sheerun/vim-polyglot'

    " Others
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'connorholyday/vim-snazzy'

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
colorscheme snazzy

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
" -----------------
" Plug-in settings
" -----------------
" devIcons
let g:webdevicons_enable = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_ctrlp = 1
let g:workspace_use_devicons = 1
" Deoplete
set completeopt-=preview
let g:deoplete#enable_at_startup = 1
let g:echodoc#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
autocmd CompleteDone * silent! pclose!
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
" NERDTree
let g:NERDTreeMouseMode = 1
let g:NERDTreeMinimalUI = 1
" Whitespaces
let g:strip_whitespace_on_save = 1
" PyMode
let g:pymode = 1
let g:pymode_python = 'python3'
let g:pymode_virtualenv = 0
let g:pymode_motion = 0
let g:pymode_indent = 1
let g:pymode_lint_cwindow = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_lint_checkers = ['pep8']
let g:pymode_lint_on_fly = 1
let g:pymode_lint_message = 1
let g:pymode_lint_todo_symbol = ''
let g:pymode_lint_error_symbol = ''
let g:pymode_lint_comment_symbol = ''
let g:pymode_rope = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
" Lightline
let g:lightline = {
      \ 'colorscheme': 'snazzy',
      \ 'component_function': {
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
let g:python_highlight_space_errors = 0
