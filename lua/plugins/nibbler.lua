return {
  'skosulor/nibbler',
  config = function()
    require('nibbler').setup({
      display_enabled = true,
    })
  end,
  keys = {
    { "<leader>nH", "<cmd>NibblerToHex<CR>", desc = "Convert number to hex", mode = "n" },
    { "<leader>nD", "<cmd>NibblerToDec<CR>", desc = "Convert number to dec", mode = "n" }
  }
}
