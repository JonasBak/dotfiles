" BEGIN VUNDLE CONFIG

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ctrlpvim/ctrlp.vim'                 "Fuzzyfinder

Plugin 'itchyny/lightline.vim'              "Statusline
Plugin 'itchyny/vim-gitbranch'              "Git branch in lightline
Plugin 'scrooloose/nerdtree'                "document tree
Plugin 'Xuyuanp/nerdtree-git-plugin'        "git flags
Plugin 'joshdick/onedark.vim'               "onedark style
Plugin 'sheerun/vim-polyglot'               "Language pack
Plugin 'valloric/youcompleteme'             "completion
Plugin 'junegunn/fzf.vim'
Plugin 'mileszs/ack.vim'
Plugin 'airblade/vim-gitgutter'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" END VUNDLE CONFIG

set rtp+=~/.fzf 

let g:ackprg = 'ag --nogroup --nocolor --column'

set updatetime=500

" General settings
syntax on
set encoding=utf8
set number
set ttimeoutlen=10         "used for key code delays
set scrolloff=10
set mouse=a
set nowrap
set noswapfile             "no stupid .swp file
set ignorecase

" Indent option, 4 spaces, also for tabs
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

" Ctrl S to save
noremap <C-s> :w<CR>
inoremap <C-s> <esc>:w<CR>a

" Go to end of line
inoremap <C-e> <C-o>A

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
inoremap "" ""<left>
inoremap '' ''<left>
inoremap `` ``<left>


" Plugin config

" CTRLP .ignore files/folders
" let g:ctrlp_max_files = 0
" noremap <M-p> :CtrlPBuffer<CR>
set wildignore+=*/venv/*,*/target/*,*/node_modules/*

" Statusline config
set laststatus=2
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" NERDTree config
noremap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden= 1
let g:NERDTreeWinSize = 25

" Colorscheme
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
""If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)

if (empty($TMUX))
    if (has("nvim"))
            "For Neovim 0.1.3 and 0.1.4 <
            "https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 <https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162>
    "Based on Vim patch 7.4.1770 (`guicolors` option) <https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd>
    " <https://github.com/neovim/neovim/wiki/Following-HEAD#20160511>
    if (has("termguicolors"))
        set termguicolors
    endif
endif
colorscheme onedark


" YCM
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
