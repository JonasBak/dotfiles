call plug#begin('~/.vim/plugged')

" Search
Plug 'junegunn/fzf.vim'

" Completion/Linting/Fixing
Plug 'dense-analysis/ale'

" Navigation
Plug 'preservim/nerdtree'

" Git
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" Visual
Plug 'jonasbak/apprentice'
Plug 'sheerun/vim-polyglot'

" Other
Plug 'tpope/vim-surround'

call plug#end()

runtime! macros/matchit.vim

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

set lazyredraw

set hidden

set undodir=$DOTFILES/local/vim_undo
set undofile

set pastetoggle=<F2>

function! Pandoc(from, to) range
  let l:output = system('echo ' . shellescape(join(getline(a:firstline, a:lastline), "\n"))
        \ . " | "
        \ . "pandoc -f " . a:from . " -t " . a:to
        \ )
  echo l:output
  if confirm("Ok?", "&Y\n&n", 1) == 1
    silent! exec ":" . a:firstline . "," . a:lastline . " delete | " . a:firstline . "-1 put =l:output"
  endif
endfunction

command! -nargs=+ -range PD <line1>,<line2>call Pandoc(<f-args>)

nnoremap <leader>p :let @p = system("wl-paste -n")<cr>"pp
nnoremap <leader>P :let @p = system("wl-paste -n")<cr>"pP
vnoremap <leader>c :w !wl-copy -n<cr>

" Indent option
filetype plugin indent on
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <leader><leader> :nohlsearch <bar> pclose <bar> lclose <bar> helpclose<cr>

" Autoclosing
inoremap (( ()<c-g>U<left>
inoremap [[ []<c-g>U<left>
inoremap {{ {}<c-g>U<left>
inoremap << <><c-g>U<left>

inoremap (<cr> (<cr>)<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap {<cr> {<cr>}<c-o>O

" Move lines
inoremap <c-j> <esc>V:move .+1<cr>==gi
inoremap <c-k> <esc>V:move .-2<cr>==gi
vnoremap <c-j> :move '>+1<cr>gv=gv
vnoremap <c-k> :move '<-2<cr>gv=gv

" Statusline config
set laststatus=2
set noshowmode

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatusLine ctermfg=010
  elseif a:mode == 'r'
    hi StatusLine ctermfg=009
  else
    hi StatusLine ctermfg=003
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline ctermfg=253

function! HandleMode()
  return ' [' . mode() . '] ' . {
        \ 0: '',
        \ 1: 'PASTE ',
        \}[&paste]
endfunction
function! HandleALE()
  let l:count = ale#statusline#Count(bufnr(''))
  return l:count.total == 0 ? '' : printf(
    \   '%dW %dE',
    \   l:count.warning,
    \   l:count.error,
    \)
endfunction

set statusline=%t       "tail of the filename
set statusline+=%{HandleMode()}
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%=      "left/right separator
set statusline+=%{HandleALE()}
set statusline+=\ %c:   "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Plugin config
let $BASE_RG = 'rg --hidden --follow --glob "!.git"'
let $FZF_DEFAULT_COMMAND = $BASE_RG . ' --files'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   $BASE_RG . ' --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <leader>1 :Files<cr>
nnoremap <leader>2 :Rg<cr>
nnoremap <leader>3 :Rg <c-r><c-w><cr>
nnoremap <leader>4 :GFiles?<cr>

" NERDTree config
noremap <c-n> :NERDTreeToggle<cr>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden= 1
let g:NERDTreeWinSize = 25

let g:NERDTreeStatusline = '%#NonText#'

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

" ALE
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    :ALEHover | ALEDetail
  endif
endfunction

let g:ale_linters = {
\   'go': ['gofmt', 'golint', 'govet', 'gopls'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'css': ['prettier'],
\   'markdown': ['prettier'],
\   'python': ['black'],
\   'rust': ['rustfmt'],
\   'go': ['gofmt']
\}
let g:ale_fix_on_save = 1

hi ALEErrorSign ctermfg=1
hi ALEWarningSign ctermfg=3

let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_column_always = 1

let g:ale_hover_cursor = 0

set completeopt=menu,menuone,noselect,noinsert
set omnifunc=ale#completion#OmniFunc

nnoremap <silent> <leader>? :call <sid>show_documentation()<cr>

nnoremap <silent> <leader>d :ALEGoToDefinition<cr>
nnoremap <silent> <leader>r :ALEFindReferences -relative<cr>

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<cr>"
inoremap <silent><expr> <tab>
      \ pumvisible() ? "\<c-n>" :
      \ "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-x>\<c-o>"
