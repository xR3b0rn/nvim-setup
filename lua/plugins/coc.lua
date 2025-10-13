return {
  "neoclide/coc.nvim",
  branch = "release",
  lazy = false,
  keys = {
    -- Normal mode keymaps for CoC actions
    { "gD",          "<Plug>(coc-declaration)",             desc = "Goto declaration",      mode = "n" },
    { "gd",          "<Plug>(coc-definition)",              desc = "Goto definition",       mode = "n" },
    { "K",           ":call CocActionAsync('doHover')<CR>", desc = "Hover",                 mode = "n" },
    { "<leader>vws", ":CocList -I symbols<CR>",             desc = "Workspace symbol",      mode = "n" },
    { "<leader>vd",  ":CocDiagnostics<CR>",                 desc = "Open diagnostics list", mode = "n" },
    { "[d",          "<Plug>(coc-diagnostic-prev)",         desc = "Prev diagnostic",       mode = "n" },
    { "]d",          "<Plug>(coc-diagnostic-next)",         desc = "Next diagnostic",       mode = "n" },
    { "<leader>vca", "<Plug>(coc-codeaction)",              desc = "Code action",           mode = "n" },
    { "<leader>vrr", "<Plug>(coc-references)",              desc = "List references",       mode = "n" },
    { "<leader>vrn", "<Plug>(coc-rename)",                  desc = "Rename symbol",         mode = "n" },
    { "<c-f>",       "<Plug>(coc-format)",                  desc = "Format file",           mode = "n" },
  },
}
