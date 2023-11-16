local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"

require "utils"

local function display(title, entry, level, seq_cur, save_last, last_item)
  local d = ""
  for i=1,level-1 do
    d = d .. "│ "
  end
  if last_item then
    d = d .. "└"
  else
    d = d .. "├"
  end
  if entry.alt ~= nil then
    d = d .. "─┬ "
  else
    d = d .. " "
  end
  d = d .. title

  if entry.seq == seq_cur then
    d = d .. " *"
  end
  if entry.save == save_last and save_last ~= nil then
    d = d .. " S"
  end

  return d
end


local function traverse_tree(ut, entries, current_content, undolist, level)
  for i=1,table.getn(entries) do
    local entry = entries[i]

    title = "Change " .. entry.seq .. " [" .. os.date("%X %x", entry.time) .. "]"
    entry.display = display(title, entry, level, ut.seq_cur, ut.save_last, i == table.getn(entries))
    entry.title = title

    table.insert(undolist, entry)

    if entry.alt ~= nil then
      traverse_tree(ut, entry.alt, current_content, undolist, level + 1)
    end
  end
end

local function generate_diff(current_content, seq)
  vim.cmd("silent undo " .. seq)

  local undo_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false) or {}, "\n")

  return vim.diff(current_content, undo_content, {ctxlen = 2})
end

local function build_undolist()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local ut = vim.fn.undotree()

  local undolist = {}

  local current_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false) or {}, "\n")

  traverse_tree(ut, ut.entries, current_content, undolist, 1)

  local undolist_reverse = {}
  for i=table.getn(undolist),1,-1 do
    table.insert(undolist_reverse, undolist[i])
  end

  local generate_diff_for = 40

  for i=1,table.getn(undolist) do
    if i <= generate_diff_for then
      undolist_reverse[i].diff = generate_diff(current_content, undolist_reverse[i].seq)
    else
      undolist_reverse[i].diff = "Diff only generated for " .. generate_diff_for .. " newest entries, press <c-d> to open diff"
    end
  end

  vim.cmd("silent undo " .. ut.seq_cur)
  vim.api.nvim_win_set_cursor(0, cursor)

  return undolist_reverse
end


function telescope_undotree(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Undo tree",
    finder = finders.new_table {
      results = build_undolist(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.seq,
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, status)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, vim.split(entry.value.diff, "\n"))
        require("telescope.previewers.utils").highlighter(
        self.state.bufnr,
        "diff",
        { preview = { treesitter = { enable = {} } } }
        )
      end
    }),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<c-d>", function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        local ut = vim.fn.undotree()

        vim.cmd("silent undo " .. selection.value.seq)

        local undo_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false) or {}, "\n")

        vim.cmd("silent undo " .. ut.seq_cur)

        vim.cmd("diffsplit " .. selection.value.title)
        vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(undo_content, "\n"))
        buf_to_scratch()
        vim.cmd("norm ]c")
      end)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("undo " .. selection.value.seq)
      end)
      return true
    end,
  }):find()
end
