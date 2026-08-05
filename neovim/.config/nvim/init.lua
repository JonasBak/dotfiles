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
  {
    'folke/which-key.nvim',
    opts = {
      icons = {
        mappings = false
      }
    }
  },
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
     severity = { min = vim.diagnostic.severity.ERROR }
   },
 }
)

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

vim.lsp.config('gopls', { on_attach = on_attach })
vim.lsp.enable('gopls')
vim.lsp.config('rust_analyzer', { on_attach = on_attach })
vim.lsp.enable('rust_analyzer')
vim.lsp.config('pyright', { on_attach = on_attach })
vim.lsp.enable('pyright')
vim.lsp.config('terraformls', { on_attach = on_attach })
vim.lsp.enable('terraformls')
-- vim.lsp.config('tsserver', { on_attach = on_attach })

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
    file_ignore_patterns = { "vendor" },
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
  { '<leader>1', '<cmd>lua require"telescope.builtin".find_files(telescope_otps_cwd_git_root())<cr>', desc = 'Search filenames'},
  { '<leader>!', '<cmd>lua require"telescope.builtin".find_files({ cwd = vim.fn.expand("%:p:h") })<cr>', desc = 'Search filenames relative to current file'},
  { '<leader>2', '<cmd>lua require"telescope.builtin".live_grep(telescope_otps_cwd_git_root())<cr>', desc = 'Search file contents'},
  { '<leader>"', '<cmd>lua telescope_grep_qflist_or_open_files()<cr>', desc = 'Search file contents'},
  { '<leader>3', '<cmd>lua require"telescope.builtin".grep_string()<cr>', desc = 'Search word under cursor'},
  { '<leader>4', '<cmd>lua require"telescope.builtin".git_status()<cr>', desc = 'Search git status files'},
  { '<leader><leader>', '<cmd>nohlsearch <bar> pclose <bar> lclose <bar> cclose <bar> helpclose <bar> cexpr []<cr>', desc = 'Close stuff'},
  { '<leader>r', '<cmd>lua require"telescope.builtin".resume()<cr>', desc = 'Resume telescope search'},
  { '<leader>t', group = 'Telescope/Treesitter'},
  { '<leader>tB', '<cmd>lua require"telescope.builtin".builtin()<cr>', desc = 'Builtin pickers' },
  { '<leader>tb', '<cmd>lua require"telescope.builtin".buffers()<cr>', desc = 'Buffers' },
  { '<leader>tj', '<cmd>lua require"telescope.builtin".jumplist()<cr>', desc = 'Jumplist' },
  { '<leader>tq', '<cmd>lua require"telescope.builtin".quickfix()<cr>', desc = 'Quickfix' },
  { '<leader>ts', '<cmd>lua require"telescope.builtin".spell_suggest()<cr>', desc = 'Spell suggest' },
  { '<leader>tt', '<cmd>lua vim.treesitter.inspect_tree()<cr>', desc = 'Syntax tree' },
  { '<leader>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', desc = 'Go to next diagnostic' },
  { '<leader>p', '<cmd>lua vim.diagnostic.goto_prev()<cr>', desc = 'Go to previous diagnostic' },
  { '<leader>c', '<cmd>lua require"treesitter-context".go_to_context()<cr>', desc = 'Go to context' },
  { '<leader>l', group = 'LSP'},
  { '<leader>lD', '<cmd>lua require"telescope.builtin".diagnostics()<cr>', desc = 'Diagnostics' },
  { '<leader>lI', '<cmd>lua require"telescope.builtin".lsp_incoming_calls()<cr>', desc = 'Incoming calls' },
  { '<leader>lO', '<cmd>lua require"telescope.builtin".lsp_outgoing_calls()<cr>', desc = 'Outgoing calls' },
  { '<leader>lR', '<cmd>lua require"telescope.builtin".lsp_references()<cr>', desc = 'References' },
  { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code action' },
  { '<leader>ld', '<cmd>lua require"telescope.builtin".lsp_definitions()<cr>', desc = 'Definitions' },
  { '<leader>lf', '<cmd>lua vim.lsp.buf.format { async = true }<cr>', desc = 'Format file' },
  { '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>', desc = 'Hover' },
  { '<leader>li', '<cmd>lua require"telescope.builtin".lsp_implementations()<cr>', desc = 'Implementations' },
  { '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', desc = 'Rename' },
  { '<leader>ls', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Show diagnostic' },
  { '<leader>lt', '<cmd>lua require"telescope.builtin".lsp_type_definitions()<cr>', desc = 'Type definitions' },
  { '<leader>g', group = 'Git'},
  { '<leader>gb', '<cmd>lua git_blame_file()<cr>', desc = 'Git blame current file' },
  { '<leader>gd', '<cmd>lua git_diff_file()<cr>', desc = 'Diff current file with HEAD' },
  { '<leader>gc', '<cmd>Telescope git_bcommits<cr>', desc = 'Commits for current file' },
  { '<leader>gr', '<cmd>lua telescope_git_diff_ref()<cr>', desc = 'Diff current file with ref' },
  { '<leader>gR', '<cmd>lua telescope_git_diff_reflog()<cr>', desc = 'Diff current file with reflog' },
  { '<leader>gA', '<cmd>split term://git add -p %<cr>', desc = 'Git add patch current file' },
  { '<leader>f', group = 'Formatting'},
  { '<leader>fp', '<cmd>silent ! prettier --write "%"<cr>', desc = 'Prettier' },
  { '<leader>ft', '<cmd>silent ! terraform fmt -write=true "%"<cr>', desc = 'Terraform' },
  { '<leader>u', '<cmd>lua telescope_undotree()<cr>', desc = 'Undotree' },
  { '<c-w>t', '<cmd>tabnew<cr>', desc = 'New tab' },
  { '<c-w>H', '<cmd>-tabnext<cr>', desc = 'Previous tab' },
  { '<c-w>L', '<cmd>tabnext<cr>', desc = 'Next tab' },
}

which_key.add(mappings_n)

local mappings_v = {
  mode = { "v" },
  { '<leader>l', desc = 'LSP' },
  { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code action' },
}

which_key.add(mappings_v)

