vim.g.vimspector_enable_mappings = "HUMAN"

vim.keymap.set('n', '<F5>', function()
  vim.cmd [[ call vimspector#Launch() ]]
end)
vim.keymap.set('n', '<F9>', function()
  vim.cmd [[ call vimspector#ToggleBreakpoint() ]]
end)
vim.keymap.set('n', '<F10>', function()
  vim.cmd [[ call vimspector#StepOver() ]]
end)
vim.keymap.set('n', '<F11>', function()
  vim.cmd [[ call vimspector#StepInto() ]]
end)

