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
        local ok, oil = pcall(require, "oil")
        local cwd = ok and oil.get_current_dir() or nil
        if not cwd then
          cwd = vim.fn.expand("%:p:h")
        end
        require('telescope').extensions.live_grep_args.live_grep_args { cwd = cwd }
      end,
      mode = { "n" },
      desc = "Live grep args (inkl. Oil Integration)"
    },
    {
      "<leader>fo",
      function()
        require('telescope.builtin').live_grep { grep_open_file = true }
      end,
      mode = { "n" },
      desc = "Live grep (nur offene Dateien)"
    },
  },
  config = function()
    local t = require('telescope')
    t.load_extension('git_grep')
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
      }
    }
  end,
}
