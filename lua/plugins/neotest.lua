return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "alfaix/neotest-gtest",
    "folke/which-key.nvim",
  },
  config = function()
    local neotest = require("neotest")
    local lib = require("neotest.lib")
    local gtest = require("neotest-gtest")

    gtest.setup({
      root = lib.files.match_root_pattern(
        "compile_commands.json",
        "compile_flags.txt",
        "WORKSPACE",
        ".clangd",
        "init.lua",
        "init.vim",
        "build",
        ".git"
      ),
      debug_adapter = "cppdbg",
      history_size = 3,
      parsing_throttle_ms = 10,
      mappings = { configure = nil },
      summary_view = {
        header_length = 80,
        shell_palette = {
          passed = "\27[32m",
          skipped = "\27[33m",
          failed = "\27[31m",
          stop = "\27[0m",
          bold = "\27[1m",
        },
      },
      extra_args = {},
    })

    neotest.setup({
      adapters = { gtest },
    })

    local wk = require("which-key")
    wk.add({
      mode = "n",
      { "<leader>tt", function() neotest.summary.toggle() end,              desc = "Toggle test summary" },
      { "<leader>tr", function() neotest.run.run() end,                     desc = "Run nearest test" },
      { "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    })
  end,
}
