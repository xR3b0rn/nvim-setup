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
        require("neotest-gtest").setup({
          debug_adapter = "cppdbg", -- oder "rt_lldb"
        }),
      },
    })
  end
}
