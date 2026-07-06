return {
  "aserowy/tmux.nvim",
  config = function()
    local tmux = require("tmux")
    local res = tmux.setup({
      disable_default_keybindings = true,
      navigation = {
        enable_default_keybindings = false,
        keybindings = {
          left = "<C-h>",
          right = "<C-l>",
          up = "<C-k>",
          down = "<C-j>",
        },
      },
      resize = {
        enable_default_keybindings = false,
      },
    })

    local set = vim.keymap.set
    set("n", "<C-h>", tmux.move_left, { silent = true, desc = "Tmux/Nvim move left" })
    set("n", "<C-l>", tmux.move_right, { silent = true, desc = "Tmux/Nvim move right" })
    set("n", "<C-j>", tmux.move_bottom, { silent = true, desc = "Tmux/Nvim move down" })
    set("n", "<C-k>", tmux.move_top, { silent = true, desc = "Tmux/Nvim move up" })

    return res
  end
}
