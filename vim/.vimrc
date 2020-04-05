call plug#begin('~/.vim/plugged')

" Search
Plug 'junegunn/fzf.vim'
Plug 'haya14busa/incsearch.vim'

" Linting
Plug 'w0rp/ale'

" Completion
if (! empty($VIM_USE_COC))
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
endif

" Navigation
Plug 'scrooloose/nerdtree'

" Git
Plug 'itchyny/vim-gitbranch'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" Visual
Plug 'itchyny/lightline.vim'
Plug 'romainl/apprentice'
Plug 'sheerun/vim-polyglot'

call plug#end()

set rtp+=~/.fzf

" General settings
set updatetime=500

set nocompatible

let mapleader = " "

syntax on
set encoding=utf8
set number
set ttimeoutlen=10
set scrolloff=10
set mouse=a
set noswapfile
set ignorecase

set lazyredraw

set undodir=$DOTFILES/local/vim_undo
set undofile

command! Q :execute "mks! " . $DOTFILES . "/local/vim_sessions/" . substitute($PWD, "\/", "\.", "g") | qa

" Indent option
filetype indent on
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Tab navigation
noremap <C-l> :tabnext<CR>
noremap <C-h> :tabprevious<CR>
noremap <C-t> :tabnew<CR>

" No arrow keys for navigation
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Autoclosing
inoremap (( ()<left>
inoremap [[ []<left>
inoremap << <><left>
inoremap {{ {}<left>

inoremap (<cr> (<cr>)<esc>O
inoremap {<cr> {<cr>}<esc>O
inoremap [<cr> [<cr>]<esc>O

nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Clipboard
nnoremap <C-c> :!echo <C-r><C-w>\| wl-copy<cr><cr>
vnoremap <C-c> :w !wl-copy<cr><cr>
nnoremap <leader>v :r !wl-paste<cr>
set pastetoggle=<F2>

nnoremap <leader><leader> :noh<cr>

" Plugin config
nnoremap <expr> <leader>1 (len(system('git rev-parse --abbrev-ref HEAD 2> /dev/null')) ? ':GFiles' : ':Files')."\<cr>"
nnoremap <leader>2 :Rg<cr>
nnoremap <leader>3 :Rg <C-r><C-w><cr>
nnoremap <leader>4 :GFiles?<cr>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Statusline config
set noshowmode
set laststatus=2
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'filename', 'modified' ] ],
      \   'right': [ [], ['cocstatus', 'percent'] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'mode': 'WrappedMode',
      \   'paste': 'WrappedPaste',
      \   'gitbranch': 'WrappedGitBranch',
      \   'filename': 'WrappedFilename',
      \   'modified': 'WrappedModified',
      \   'lineinfo': 'WrappedLineInfo',
      \   'percent': 'WrappedPercent'
      \ },
      \ 'colorscheme': 'srcery_drk',
      \ }

source $DOTFILES/utils/vim/lightline_functions.vim

" NERDTree config
noremap <C-n> :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden= 1
let g:NERDTreeWinSize = 25

" Colorscheme
if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
        set termguicolors
    endif
endif

silent! colorscheme apprentice
hi VertSplit ctermbg=235 ctermfg=234
hi StatusLineNC ctermbg=235 ctermfg=235
hi StatusLine ctermbg=235 ctermfg=235

let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle

" ALE
hi ALEErrorSign ctermfg=1
hi ALEwarningSign ctermfg=3

let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'

let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config=1
let g:ale_rust_cargo_use_check = 1
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'javascript': ['prettier'],
      \   'typescript': ['prettier'],
      \   'typescriptreact': ['prettier'],
      \   'css': ['prettier'],
      \   'c': ['clang-format'],
      \   'cuda': ['clang-format'],
      \   'python': ['isort', 'black'],
      \   'java': ['google_java_format'],
      \   'rust': ['rustfmt'],
      \   'c++': ['clang-format'],
      \   'sh': ['shfmt'],
      \   'go': ['gofmt']
      \}

" CoC
if (! empty($VIM_USE_COC))
  set hidden
  set nobackup
  set nowritebackup
  set shortmess+=c
  set signcolumn=yes

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  nmap <silent> <Leader>g <Plug>(coc-definition)
  nmap <silent> <Leader>r <Plug>(coc-references)
  nmap <Leader>R <Plug>(coc-rename)
  nnoremap <silent> <Leader>? :call <SID>show_documentation()<CR>

  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endif
