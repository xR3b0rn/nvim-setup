return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    require("telescope").load_extension("live_grep_args")
    local lga_actions = require("telescope-live-grep-args.actions")
    require("telescope").setup {
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
