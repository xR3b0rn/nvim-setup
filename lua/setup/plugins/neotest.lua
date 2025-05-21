return {
  "nvim-neotest/neotest",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "Shatur/neovim-tasks",
    "rosstang/neotest-catch2",
    "alfaix/neotest-gtest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        -- require("neotest-catch2")({ }),
        require("neotest-gtest").setup({}),
      }
    })
  end
}
