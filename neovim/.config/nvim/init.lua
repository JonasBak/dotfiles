vim.cmd("source ~/.vimrc")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { 'nvim-telescope/telescope.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'airblade/vim-gitgutter' },
  { 'folke/which-key.nvim' },
  { 'tpope/vim-surround' },
  { 'jonasbak/apprentice' },
}

local lazy_opts = {
}

require("lazy").setup(plugins, lazy_opts)

require "git"
require "undo"

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
lspconfig.rust_analyzer.setup{ on_attach = on_attach }
lspconfig.pyright.setup{ on_attach = on_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.terraformls.setup{ on_attach = on_attach }

vim.cmd 'silent! colorscheme apprentice'

-- Treesitter

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c",
    "c_sharp",
    "go",
    "hcl",
    "java",
    "javascript",
    "json",
    "lua",
    "python",
    "rust",
    "terraform",
    "toml",
    "typescript",
    "yaml",
    "zig",
  },
  highlight = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["as"] = { query = "@scope", query_group = "locals" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

require'treesitter-context'.setup{
  max_lines = 1,
  multiline_threshold = 1,
  trim_scope = 'inner',
  mode = 'cursor',
}

vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Comment" })
vim.api.nvim_set_hl(0, "TreesitterContextBottom", { link = "Comment" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Comment" })

vim.o.foldmethod = 'expr'
vim.o.foldlevelstart = 99
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- telescope

local telescope_actions = require('telescope.actions')
local telescope_config = require("telescope.config")
local telescope = require('telescope')

local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup{
  defaults = {
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close,
        ["<c-k>"] = telescope_actions.move_selection_previous,
        ["<c-j>"] = telescope_actions.move_selection_next,
        ["<c-a>"] = telescope_actions.select_all,
        ["<c-f>"] = telescope_actions.to_fuzzy_refine,
        ["<c-v>"] = telescope_actions.smart_send_to_qflist,
        ["<c-s>"] = telescope_actions.select_horizontal,
        ["<c-t>"] = telescope_actions.select_tab,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    live_grep = {
      find_command = { "rg", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

telescope.load_extension('fzf')
telescope.load_extension("ui-select")

-- which-key

local which_key = require "which-key"

local mappings_n = {
  ['<leader>'] = {
    ['1'] = {'<cmd>lua require"telescope.builtin".find_files(telescope_otps_cwd_git_root())<cr>', 'Search filenames'},
    ['!'] = {'<cmd>lua require"telescope.builtin".find_files({ cwd = vim.fn.expand("%:p:h") })<cr>', 'Search filenames relative to current file'},
    ['2'] = {'<cmd>lua require"telescope.builtin".live_grep(telescope_otps_cwd_git_root())<cr>', 'Search file contents'},
    ['"'] = {'<cmd>lua telescope_grep_qflist_or_open_files()<cr>', 'Search file contents'},
    ['3'] = {'<cmd>lua require"telescope.builtin".grep_string()<cr>', 'Search word under cursor'},
    ['4'] = {'<cmd>lua require"telescope.builtin".git_status()<cr>', 'Search git status files'},
    ['<leader>'] = {'<cmd>nohlsearch <bar> pclose <bar> lclose <bar> cclose <bar> helpclose <bar> cexpr []<cr>', 'Close stuff'},
    r = {'<cmd>lua require"telescope.builtin".resume()<cr>', 'Resume telescope search'},
    t = {
      name = 'Telescope/Treesitter',

      B = { '<cmd>lua require"telescope.builtin".builtin()<cr>', 'Builtin pickers' },
      b = { '<cmd>lua require"telescope.builtin".buffers()<cr>', 'Buffers' },
      j = { '<cmd>lua require"telescope.builtin".jumplist()<cr>', 'Jumplist' },
      q = { '<cmd>lua require"telescope.builtin".quickfix()<cr>', 'Quickfix' },
      s = { '<cmd>lua require"telescope.builtin".spell_suggest()<cr>', 'Spell suggest' },

      t = { '<cmd>lua vim.treesitter.inspect_tree()<cr>', 'Syntax tree' }
    },
    n = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Go to next diagnostic' },
    p = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Go to previous diagnostic' },
    c = { '<cmd>lua require"treesitter-context".go_to_context()<cr>', 'Go to context' },
    l = {
      name = 'LSP',
      D = { '<cmd>lua require"telescope.builtin".diagnostics()<cr>', 'Diagnostics' },
      I = { '<cmd>lua require"telescope.builtin".lsp_incoming_calls()<cr>', 'Incoming calls' },
      O = { '<cmd>lua require"telescope.builtin".lsp_outgoing_calls()<cr>', 'Outgoing calls' },
      R = { '<cmd>lua require"telescope.builtin".lsp_references()<cr>', 'References' },
      a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action' },
      d = { '<cmd>lua require"telescope.builtin".lsp_definitions()<cr>', 'Definitions' },
      f = { '<cmd>lua vim.lsp.buf.format { async = true }<cr>', 'Format file' },
      h = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover' },
      i = { '<cmd>lua require"telescope.builtin".lsp_implementations()<cr>', 'Implementations' },
      r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
      s = { '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show diagnostic' },
      t = { '<cmd>lua require"telescope.builtin".lsp_type_definitions()<cr>', 'Type definitions' },
    },
    g = {
      name = 'Git',
      b = { '<cmd>lua git_blame_file()<cr>', 'Git blame current file' },
      d = { '<cmd>lua git_diff_file()<cr>', 'Diff current file with HEAD' },
      c = { '<cmd>Telescope git_bcommits<cr>', 'Commits for current file' },
      r = { '<cmd>lua telescope_git_diff_ref()<cr>', 'Diff current file with ref' },
      R = { '<cmd>lua telescope_git_diff_reflog()<cr>', 'Diff current file with reflog' },
    },
    f = {
      name = 'Formatting',
      p = { '<cmd>silent ! prettier --write "%"<cr>', 'Prettier' },
      t = { '<cmd>silent ! terraform fmt -write=true "%"<cr>', 'Terraform' },
    },
    u = { '<cmd>lua telescope_undotree()<cr>', 'Undotree' },
  },
  ['<c-w>'] = {
    t = { '<cmd>tabnew<cr>', 'New tab' },
    H = { '<cmd>-tabnext<cr>', 'Previous tab' },
    L = { '<cmd>tabnext<cr>', 'Next tab' },
  },
}

local opts_n = {
  mode = "n",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}

which_key.register(mappings_n, opts_n)

local mappings_v = {
  ['<leader>'] = {
    l = {
      name = 'LSP',
      a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action' },
    },
  },
}

local opts_v = {
  mode = "v",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}

which_key.register(mappings_v, opts_v)
