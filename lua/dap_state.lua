local M = {}

-- True whenever debugging is in progress *or* dapui panels are simply
-- visible right now. Checking dap.session() alone misses two real cases:
-- a session that crashed a moment ago and hasn't been cleaned up yet, and
-- cmake-tools' own pre-debug build step (cmake.debug() always builds
-- before it launches, and that build can pop the quickfix window while
-- dap.session() is still nil since the debug session itself hasn't
-- started).
function M.is_dap_active()
  local ok, dap = pcall(require, "dap")
  if ok and dap.session() then
    return true
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
    if ft:match("^dap") then
      return true
    end
  end
  return false
end

return M
