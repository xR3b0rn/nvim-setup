vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gl", vim.cmd.Gclog)
vim.keymap.set("n", "<leader>gp", function()
  local vn = "cur-git-behind-head"
  local ok, var = pcall(vim.api.nvim_buf_get_var, 0, vn)
  if not ok then
    var = 0
  end
  var = var + 1
  vim.cmd.Gedit("HEAD~" .. var .. ":%")
  vim.api.nvim_buf_set_var(0, vn, var)
end)
