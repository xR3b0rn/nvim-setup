
require('telescope').setup {
  extensions = {
    git_grep = {
      additional_args = {
        "--recurse-submodules"
      }
    }
  }
}
require('telescope').load_extension('git_grep')
local ts = require('telescope.builtin')
local tsg = require('git_grep')

vim.keymap.set('n', '<leader>ff', ts.find_files, {})
--vim.keymap.set('n', '<leader>fg', ts.live_grep, {})
vim.keymap.set('n', '<leader>fg', function() tsg.live_grep() end)
vim.keymap.set('n', '<leader>fb', ts.buffers, {})
vim.keymap.set('n', '<leader>fh', ts.help_tags, {})
vim.keymap.set('n', '<leader>fd', ts.diagnostics, {})
vim.keymap.set('n', '<leader>ft', ts.treesitter, {})
vim.keymap.set('n', '<leader>fr', ts.lsp_references, {})
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) 
