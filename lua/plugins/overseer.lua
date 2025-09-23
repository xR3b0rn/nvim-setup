return {
  'stevearc/overseer.nvim',
  config = function()
    local overseer = require("overseer")
    local dap = require("dap")

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
