return {
  "folke/snacks.nvim",
  opts = {
    input = {
      enabled = true,
    },
    picker = {
      enabled = true,
    }
  },
  config = function()
    local snacks = require("snacks")
    vim.ui.select = snacks.picker.select
    vim.ui.input = snacks.input 
  end
}
