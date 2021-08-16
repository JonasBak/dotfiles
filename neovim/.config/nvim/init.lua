vim.api.nvim_exec(
[[
call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-surround'

Plug 'jonasbak/apprentice'

call plug#end()

source ~/.vimrc

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
]],
false)

-- LSP

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = {
     severity_limit = "Error",
   },
 }
)

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local lspconfig = require'lspconfig'

lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.rls.setup{ on_attach = on_attach }
lspconfig.pyright.setup{ on_attach = on_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }

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

vim.api.nvim_exec(
[[
sign define LspDiagnosticsSignError text=█ texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=█ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=█ texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=█ texthl=LspDiagnosticsSignHint linehl= numhl=

highlight LspDiagnosticsFloatingError ctermfg=1
highlight LspDiagnosticsFloatingWarning ctermfg=3
highlight LspDiagnosticsFloatingInformation ctermfg=15
highlight LspDiagnosticsFloatingHint ctermfg=15

highlight LspDiagnosticsVirtualTextError ctermfg=1
highlight LspDiagnosticsVirtualTextWarning ctermfg=8
highlight LspDiagnosticsVirtualTextInformation ctermfg=8
highlight LspDiagnosticsVirtualTextHint ctermfg=8

highlight LspDiagnosticsSignError ctermfg=1
highlight LspDiagnosticsSignWarning ctermfg=8
highlight LspDiagnosticsSignInformation ctermfg=8
highlight LspDiagnosticsSignHint ctermfg=8

highlight LspDiagnosticsUnderlineError ctermfg=1
]],
false)

-- Treesitter

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  -- highlight = {
  --   enable = true
  -- },
  -- indent = {
  --   enable = true
  -- }
}

vim.api.nvim_exec(
[[
set foldmethod=expr
set foldlevelstart=99
set foldexpr=nvim_treesitter#foldexpr()
]],
false)
