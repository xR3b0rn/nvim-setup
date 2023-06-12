
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--vim.keymap.set("n", "<C-F>", function()
--  if vim.bo.filetype == "cpp" then
--    return ":pyf /usr/share/clang/clang-format-10/clang-format.py<cr>"
--  end
--end, { expr = true })

vim.keymap.set("v", "<C-F>", function()
  return ":pyf /usr/share/clang/clang-format-10/clang-format.py<cr>"
end, { expr = true })

