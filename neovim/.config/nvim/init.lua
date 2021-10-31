vim.api.nvim_exec(
[[
source ~/.vimrc
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
]],
false)

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  use 'neovim/nvim-lspconfig'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  use 'airblade/vim-gitgutter'

  use 'folke/which-key.nvim'

  use 'tpope/vim-surround'

  use 'jonasbak/apprentice'
end)

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
  highlight = {
    enable = true
  },
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

--- which-key

local which_key = require "which-key"

local mappings = {
  ['<leader>'] = {
    ['1'] = {'<cmd>Files<cr>', 'Search filenames'},
    ['2'] = {'<cmd>Rg<cr>', 'Search file contents'},
    ['3'] = {'<cmd>Rg <c-r><c-w><cr>', 'Search word under cursor'},
    ['4'] = {'<cmd>GFiles?<cr>', 'Search git diff'},
    ['<leader>'] = {'<cmd>nohlsearch <bar> pclose <bar> lclose <bar> cclose <bar> helpclose<cr>', 'Close stuff'},
    l = {
      name = 'LSP mappings',
      d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition' },
      f = { '<cmd>lua vim.lsp.buf.formatting()<cr>', 'Format file' },
      h = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover' },
      r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
      R = { '<cmd>lua vim.lsp.buf.references()<cr>', 'References' },
      s = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', 'Show diagnostic' },
      n = { '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'Go to next diagnostic' },
      l = { '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', 'Loclist' },
      a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action' },
    },
    g = {
      name = 'Git mappings',
      b = { '<cmd>split <bar> terminal git --no-pager blame "%"<cr>', 'Git blame current file' },
      l = { '<cmd>split <bar> terminal git --no-pager log -- "%"<cr>', 'Git log current file' },
      d = { '<cmd>call DiffRef("HEAD", expand("%"))<cr>', 'Git diff current file' },
      D = { '<cmd>ShowDiffsCurrentFile<cr>', 'Git diff in diff mode' },
    },
    f = {
      name = 'Formatting',
      p = { '<cmd>silent ! prettier --write "%"<cr>', 'Prettier' },
      t = { '<cmd>silent ! terraform fmt -write=true "%"<cr>', 'Terraform' },
    },
  },
  ['<c-w>'] = {
    t = { '<cmd>tabnew<cr>', 'New tab' },
    H = { '<cmd>-tabnext<cr>', 'Previous tab' },
    L = { '<cmd>tabnext<cr>', 'Next tab' },
  },
}
local opts = {
  mode = "n",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}

which_key.register(mappings, opts)

-- Functions and stuff

vim.api.nvim_exec(
[[
function DiffRef(ref, file)
  setlocal noreadonly
  let fileref = a:ref . ':' . a:file
  exec 'diffsplit ' . fileref
  exec '%! git show ' . fileref
  lua into_scratch()

  let b:is_git_buffer = 1

  nmap <buffer> <c-n> <cmd>call DiffNewerCommit()<cr>
  nmap <buffer> <c-p> <cmd>call DiffOlderCommit()<cr>
endfunction

function DiffRefFromLog(logref)
  let ref = split(a:logref)[0]
  if exists("b:is_git_buffer")
    bwipeout %
  endif
  let file = expand('%')
  call DiffRef(ref, file)
endfunction

function DiffNewerCommit()
  let bufferName = split(expand('%'), ':')
  let ref = bufferName[0]
  bwipeout %
  let file = expand('%')
  let newer = system('echo -n "$(git log --format=%h ' . ref . '..HEAD | tail -n 1)"')
  call DiffRef(newer, file)
endfunction

function DiffOlderCommit()
  let bufferName = split(expand('%'), ':')
  let ref = bufferName[0]
  bwipeout %
  let file = expand('%')
  let older = system('echo -n "$(git log -n 1 --format=%h ' . ref . '^1)"')
  call DiffRef(older, file)
endfunction

function FzfChooseCommit(sink)
  call fzf#run(fzf#wrap({'source': 'git log --abbrev-commit --format=oneline --decorate', 'sink': a:sink}))
endfunction

command! -nargs=1 DiffRefFromLog :call DiffRefFromLog(<q-args>)
command! ShowDiffsCurrentFile :call FzfChooseCommit('DiffRefFromLog')
]],
false)

function into_scratch()
  vim.api.nvim_exec(
  [[
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal readonly
    " setlocal nomodifiable
  ]],
  false)
end
