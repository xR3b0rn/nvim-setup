
require('telescope').load_extension('git_grep')
local ts = require('telescope.builtin')
local tsg = require('git_grep')

-- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>ps', function()
--  builtin.grep_string({ search = vim.fn.input("Grep > ") });
--end)

vim.keymap.set('n', '<leader>ff', ts.find_files, {})
--vim.keymap.set('n', '<leader>fg', ts.live_grep, {})
vim.keymap.set('n', '<leader>fg', function() tsg.live_grep() end)
vim.keymap.set('n', '<leader>fb', ts.buffers, {})
vim.keymap.set('n', '<leader>fh', ts.help_tags, {})
vim.keymap.set('n', '<leader>fd', ts.diagnostics, {})
vim.keymap.set('n', '<leader>fr', ts.lsp_references, {})
