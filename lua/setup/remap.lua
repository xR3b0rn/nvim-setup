
vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "", {
  noremap = true,
  callback = function()
    require("ranger-nvim").open(true)
  end,
})

vim.cmd [[
  let g:netrw_fastbrowse = 2
  let g:netrw_preview = 1
  let g:mkdp_auto_start = 0
]]
