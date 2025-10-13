return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  keys = {
    {
      "<leader>fg",
      function()
        require('telescope').extensions.live_grep_args.live_grep_args { cwd = "%:p:h" }
      end,
      mode = { "n" },
      desc = "live grep args"
    },
    {
      "<leader>fo",
      function()
        require('telescope.builtin').live_grep { grep_open_file = true }
      end,
      mode = { "n" },
      desc = "live grep"
    },
  },
  config = function()
    local t = require('telescope')
    t.load_extension('git_grep')
    t.load_extension("live_grep_args")
    t.load_extension("live_grep_args")
    local lga_actions = require("telescope-live-grep-args.actions")
    t.setup {
      extensions = {
        git_grep = {
          additional_args = {
            "--recurse-submodules"
          }
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
            },
          },
        }
      } }
  end,
};
