return {
  "dpayne/CodeGPT.nvim",
  requires = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codegpt.config")
  end
}
