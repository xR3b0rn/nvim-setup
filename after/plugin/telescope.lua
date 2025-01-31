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
