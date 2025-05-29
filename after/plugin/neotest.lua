local neotest = require("neotest")

local wk = require("which-key")
wk.add({
  {
    mode = "n",
    { "<leader>tt", neotest.summary.toggle,                               desc = "Toggle neotest summary" },
    { "<leader>tr", neotest.run.run,                                      desc = "Run nearest neotest" },
    { "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, desc = "Debug nearest neotest" },
  }
})
