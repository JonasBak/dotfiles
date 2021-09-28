set nocompatible

filetype plugin indent on
syntax on

runtime! macros/matchit.vim

set noswapfile
set hidden
set autoread

set encoding=utf8
set mouse=a
set ttimeoutlen=10
set scrolloff=10
set updatetime=500
set number
set lazyredraw

set undodir=/tmp/vim_undo
set undofile

set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

set hlsearch
set incsearch
set ignorecase
set smartcase

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 18

let mapleader = " "

nnoremap <leader><leader> :nohlsearch <bar> pclose <bar> lclose <bar> cclose <bar> helpclose<cr>

nnoremap <leader>p :let @p = system("wl-paste -n")<cr>"pp
nnoremap <leader>P :let @p = system("wl-paste -n")<cr>"pP
vnoremap <leader>c :w !wl-copy -n<cr>

nnoremap <c-n> :Lexplore<cr>

inoremap (<cr> (<cr>)<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap {<cr> {<cr>}<c-o>O
