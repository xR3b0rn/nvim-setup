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
        local cwd
        if vim.bo.filetype == "oil" then
          local ok, oil = pcall(require, "oil")
          if ok then
            cwd = oil.get_current_dir()
          end
        else
          cwd = vim.fn.expand("%:p:h")
        end
        cwd = cwd or vim.fn.getcwd()
        cwd = cwd:gsub("^oil://", "")
        cwd = vim.fn.fnamemodify(cwd, ":p")
        cwd = cwd:gsub("[/\\]$", "")
        require('telescope').extensions.live_grep_args.live_grep_args({
          search_dirs = { cwd }
        })
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
    t.load_extension('git_grep')
    t.load_extension("live_grep_args")
  end,
}
