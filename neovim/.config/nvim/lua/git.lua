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
end

function git_blame_file()
  local file = vim.fn.expand("%")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd("split git blame " .. file)
  vim.cmd("%! git blame " .. file)
  buf_to_scratch()
  vim.cmd(":" .. line)
end
