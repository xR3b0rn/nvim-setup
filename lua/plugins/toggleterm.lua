return {
  "akinsho/toggleterm.nvim",
  config = function()
    local tt = require("toggleterm")
    tt.setup {
      open_mapping = [[<c-\>]],
      direction    = "float",
    }
  end,
}
