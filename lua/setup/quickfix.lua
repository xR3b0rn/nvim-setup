-- Make the quickfix window behave predictably no matter which plugin opened
-- it (`:copen`, cmake-tools, overseer's on_output_quickfix, ...):
--   1. it always spans the full width at the very bottom of the tabpage,
--      instead of appearing as a split wedged between other windows.
--   2. jumping to an entry (<CR>/double-click/`o`) opens the file in the
--      window that was active right before the quickfix window opened, but
--      never in a dap/dapui window, so the debugger layout never gets
--      clobbered.

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
  -- Vim's own "alternate window" reliably still points at the window that
  -- was active right before the quickfix window opened, even though :copen
  -- internally hops through window 1 while it looks for an existing
  -- quickfix window (which would otherwise corrupt a naive MRU stack).
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

local function open_entry(close)
  local qf_win = vim.api.nvim_get_current_win()
  local idx = vim.fn.line(".")
  local target = vim.w[qf_win].qf_target_win
  if not is_usable_target(target, qf_win) then
    target = find_target_window(qf_win)
  end
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

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  callback = function(args)
    local qf_win = vim.api.nvim_get_current_win()
    vim.w[qf_win].qf_target_win = find_target_window(qf_win)

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
