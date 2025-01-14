local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"

require "utils"

function git_diff_file()
  local file = vim.fn.expand("%")
  vim.cmd("diffsplit HEAD:" .. file)
  vim.cmd("%! git show HEAD:" .. file)
  buf_to_scratch()
  vim.cmd("norm ]c")
end

function git_blame_file()
  local file = vim.fn.expand("%")
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd("split git blame " .. file)
  vim.cmd("%! git blame " .. file)
  buf_to_scratch()
  vim.api.nvim_win_set_cursor(0, cursor)
end

local function get_refs()
  local out = vim.fn.system("git for-each-ref")
  local lines = vim.split(out, "\n")

  local refs = {}
  for _, line in ipairs(lines) do
    local c, ref = unpack(vim.split(line, "\t"))
    local hash, t = unpack(vim.split(c, " "))
    if t == "commit" then
      table.insert(refs, ref)
    end
  end

  return refs
end

function telescope_git_diff_ref(opts)
  opts = opts or {}

  local file = vim.fn.expand("%")
  pickers.new(opts, {
    prompt_title = "Diff file with ref",
    finder = finders.new_table {
      results = get_refs(),
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_termopen_previewer({
      get_command = function(entry, status)
        return {"git", "diff", entry[1], "--", file}
      end
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local ref = selection[1]
        local diff_buf_file = ref .. ":" .. vim.fn.expand("%")
        vim.cmd("diffsplit " .. diff_buf_file)
        vim.cmd("%! git show " .. diff_buf_file)
        buf_to_scratch()
        vim.cmd("norm ]c")
      end)
      return true
    end,
  }):find()
end

local function get_reflog()
  local out = vim.fn.system("git reflog")
  local lines = vim.split(out, "\n")

  return lines
end

function telescope_git_diff_reflog(opts)
  opts = opts or {}

  local file = vim.fn.expand("%")
  pickers.new(opts, {
    prompt_title = "Diff file with commit",
    finder = finders.new_table {
      results = get_reflog(),
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_termopen_previewer({
      get_command = function(entry, status)
        local commit = vim.split(entry[1], " ")[1]
        return {"git", "diff", commit, "--", file}
      end
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local commit = vim.split(selection[1], " ")[1]
        local diff_buf_file = commit .. ":" .. vim.fn.expand("%")
        vim.cmd("diffsplit " .. diff_buf_file)
        vim.cmd("%! git show " .. diff_buf_file)
        buf_to_scratch()
        vim.cmd("norm ]c")
      end)
      return true
    end,
  }):find()
end

