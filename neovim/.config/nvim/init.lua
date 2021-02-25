vim.api.nvim_exec(
[[
call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lspconfig'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-surround'

Plug 'jonasbak/apprentice'

call plug#end()

source ~/.vimrc

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
]],
false)

local lspconfig = require'lspconfig'

lspconfig.gopls.setup{}
lspconfig.rls.setup{}
lspconfig.pyright.setup{}
lspconfig.tsserver.setup{}

vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

local map = vim.api.nvim_set_keymap
local options = {noremap = true, silent = true}

map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<cr>', options)
map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', options)
map('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<cr>', options)
map('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', options)
map('n', '<leader>s', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', options)
map('n', '<leader>n', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', options)
map('n', '<leader>l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', options)

map('n', '<leader>1', '<cmd>Files<cr>', options)
map('n', '<leader>2', '<cmd>Rg<cr>', options)
map('n', '<leader>3', ':Rg <c-r><c-w><cr>', options)
map('n', '<leader>4', '<cmd>GFiles?<cr>', options)

vim.cmd 'silent! colorscheme apprentice'
