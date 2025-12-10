return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require("overseer")
    overseer.setup({
      task_list = {
        direction = "bottom",
        bindings = {
          ["q"] = function()
            vim.cmd("close")
          end,
        },
      },
    })
  end,
}
