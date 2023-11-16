local telescope_builtin = require "telescope.builtin"

function dbg(v)
  print(vim.inspect(v))
end

function buf_to_scratch()
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "delete"
  vim.opt_local.readonly = true
end

function telescope_grep_qflist_or_open_files()
  local qflist = vim.fn.getqflist()
  if table.getn(qflist) == 0 then
    return telescope_builtin.live_grep({ grep_open_files = true, prompt_title = "Grep open files" })
  end
  local files = {}
  for i=1,table.getn(qflist) do
    table.insert(files, vim.fn.bufname(qflist[i].bufnr))
  end
  return telescope_builtin.live_grep({ search_dirs = files, prompt_title = "Grep files in qflist (" .. table.getn(files) .. " items)" })
end

function telescope_otps_cwd_git_root()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}
  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  return opts
end
