vim.g.mapleader = " "

local diagnostics_str = '<cmd>lua vim.diagnostic.open_float()<CR>'

local wk = require("which-key")
wk.add({
  {
    mode = { "n" },
    { "<leader>pv", vim.cmd.Ex,        desc = "file exporer" },
    { "<leader>gg", vim.cmd.LazyGit,   desc = "LazyGit" },
    { "<leader>e",  diagnostics_str,   desc = "float diagnostics" },
  }
})
