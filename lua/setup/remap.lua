
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--vim.keymap.set("n", "<C-F>", function()
--  if vim.bo.filetype == "cpp" then
--    return ":pyf /usr/share/clang/clang-format-10/clang-format.py<cr>"
--  end
--end, { expr = true })

vim.keymap.set("v", "<C-F>", function()
  if vim.bo.filetype == "cpp" then
    local handle = io.popen("ls -l $(which clang-format) | awk '{ print $11 }' | tr -d '[:space:]'")
    local cf = handle:read("*a")
    handle:close()
    if not (cf == "") then
      return ":pyf /usr/share/clang/" .. cf .. "/clang-format.py<cr>"
    else
      error("could not find clang-format.py")
    end
  end
end, { expr = true })
