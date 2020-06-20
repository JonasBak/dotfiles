call plug#begin('~/.vim/plugged')

" Search
Plug 'junegunn/fzf.vim'

" Completion
if (! empty($VIM_USE_COC))
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
endif

" Navigation
Plug 'preservim/nerdtree'

" Git
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" Visual
Plug 'romainl/apprentice'
Plug 'sheerun/vim-polyglot'

call plug#end()

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

command! Trim :%s/\s\+$//e

set pastetoggle=<F2>

" Indent option
filetype indent on
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Navigation
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <leader><leader> :noh<cr>

" Autoclosing
inoremap (( ()<c-g>U<left>
inoremap [[ []<c-g>U<left>
inoremap {{ {}<c-g>U<left>
inoremap << <><c-g>U<left>

inoremap (<cr> (<cr>)<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap {<cr> {<cr>}<c-o>O

" Move lines
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Statusline config
set laststatus=2
set noshowmode
function! HandleMode()
  if (mode() =~# '\v(n|no)')
    hi StatusLine ctermfg=252
  elseif (mode() ==# 'i')
    hi StatusLine ctermfg=010
  else
    hi StatusLine ctermfg=003
  endif
  return ' [' . mode() . '] ' . {
        \ 0: '',
        \ 1: 'PASTE ',
        \}[&paste]
endfunction

set statusline=%t       "tail of the filename
set statusline+=%{HandleMode()}
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%=      "left/right separator
if (! empty($VIM_USE_COC))
  set statusline+=[%{coc#status()}]
endif
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
nnoremap <leader>3 :Rg <C-r><C-w><cr>
nnoremap <leader>4 :GFiles?<cr>

" NERDTree config
noremap <C-n> :NERDTreeToggle<CR>
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
hi VertSplit ctermbg=235 ctermfg=234
hi StatusLine ctermbg=235 ctermfg=242
hi StatusLineNC ctermbg=235 ctermfg=242

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

  nmap <silent> <leader>g <Plug>(coc-definition)
  nmap <silent> <leader>r <Plug>(coc-references)
  nmap <leader>R <Plug>(coc-rename)

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> <Leader>? :call <SID>show_documentation()<CR>

  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endif
