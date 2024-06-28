local lga_actions = require("telescope-live-grep-args.actions")
local action_state = require("telescope.actions.state")

local default_opts = {
  quote_char = '"',
  postfix = " ",
  trim = true,
}

require('telescope').setup {
  extensions = {
    git_grep = {
      additional_args = {
        "--recurse-submodules"
      }
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = {         -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}
local t = require('telescope')
t.load_extension('git_grep')
t.load_extension("live_grep_args")

local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ts.find_files, {})
vim.keymap.set('n', '<leader>fg', function() t.extensions.live_grep_args.live_grep_args { cwd = "%:p:h" } end, {})
vim.keymap.set('n', '<leader>fo', function() ts.live_grep { grep_open_file=true } end, {})
vim.keymap.set('n', '<leader>fb', ts.buffers, {})
vim.keymap.set('n', '<leader>fh', ts.help_tags, {})
vim.keymap.set('n', '<leader>fd', ts.diagnostics, {})
vim.keymap.set('n', '<leader>ft', ts.treesitter, {})
vim.keymap.set('n', '<leader>fr', ts.lsp_references, {})
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
