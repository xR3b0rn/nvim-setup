-- Make the quickfix window behave predictably no matter which plugin opened
-- it (`:copen`, cmake-tools, overseer's on_output_quickfix, ...):
--   1. it always spans the full width at the very bottom of the tabpage,
--      instead of appearing as a split wedged between other windows -- except
--      during an active debug session, where forcing that reshapes dapui's
--      docked panels too and its size drifts further off with each build.
--   2. jumping to an entry (<CR>/double-click/`o`) opens the file in the
--      window that was active most recently, but never in a dap/dapui
--      window, so the debugger layout never gets clobbered.

local group = vim.api.nvim_create_augroup("CustomQuickfix", { clear = true })

-- Fallback history of recently focused windows. Only used when Vim's own
-- "alternate window" (see find_target_window) isn't usable, e.g. because it
-- is itself a dap window.
local mru = {}

local function forget_window(win)
  for i, w in ipairs(mru) do
    if w == win then
      table.remove(mru, i)
      return
    end
  end
end

vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    forget_window(win)
    table.insert(mru, 1, win)
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = group,
  callback = function(args)
    forget_window(tonumber(args.match))
  end,
})

local function is_dap_window(win)
  local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
  return ft:match("^dap") ~= nil
end

local function is_usable_target(win, exclude)
  if not win or win == exclude or not vim.api.nvim_win_is_valid(win) then
    return false
  end
  if vim.api.nvim_win_get_tabpage(win) ~= vim.api.nvim_get_current_tabpage() then
    return false
  end
  if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
    return false
  end
  return not is_dap_window(win)
end

local function find_target_window(exclude)
  -- Vim's own "alternate window" is usually the window that was active
  -- right before the current one.
  local alt = vim.fn.win_getid(vim.fn.winnr("#"))
  if is_usable_target(alt, exclude) then
    return alt
  end
  for _, win in ipairs(mru) do
    if is_usable_target(win, exclude) then
      return win
    end
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_usable_target(win, exclude) then
      return win
    end
  end
  return nil
end

-- Deliberately not cached: the target window is (re-)computed fresh on
-- every jump instead of once when the quickfix window was opened. Caching
-- it at open-time is fragile -- e.g. `wincmd J` below can make Vim briefly
-- refocus another window while it repositions the quickfix window, which
-- would corrupt a captured value with whatever window Vim's internal
-- window-tree traversal happens to touch during that reposition.
local function open_entry(close)
  local qf_win = vim.api.nvim_get_current_win()
  local idx = vim.fn.line(".")
  local target = find_target_window(qf_win)
  if not target then
    vim.notify("quickfix: no suitable window to open the entry in", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_set_current_win(target)
  if close and vim.api.nvim_win_is_valid(qf_win) then
    vim.api.nvim_win_close(qf_win, true)
  end
  vim.cmd(idx .. "cc")
end

local is_dap_active = require("dap_state").is_dap_active

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  callback = function(args)
    if is_dap_active() then
      -- Capturing dap panel sizes here and restoring them after close
      -- doesn't work:
      -- by the time this FileType autocmd fires, the window this hooks into
      -- already exists and its siblings have already been shrunk to make
      -- room for it (there's no earlier hook to intervene before that
      -- happens). Closing immediately at least stops it from growing
      -- further; see cmake-tools.lua for the actual fix, which stops the
      -- window from being created in the first place during cmake builds.
      vim.api.nvim_win_close(0, true)
      return
    end

    -- `wincmd J` forces full-width bottom placement (like closing the
    -- window and reopening it in the new position).
    vim.cmd("wincmd J")
    vim.wo.winfixheight = true

    -- Deferred so this overrides nvim-bqf's own <CR>/`o` mapping for this
    -- buffer regardless of autocmd/plugin-load ordering.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      local opts = { buffer = args.buf, nowait = true, silent = true }
      vim.keymap.set("n", "<CR>", function() open_entry(false) end, opts)
      vim.keymap.set("n", "o", function() open_entry(true) end, opts)
    end)
  end,
})
