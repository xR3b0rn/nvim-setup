return {
  "aserowy/tmux.nvim",
  config = function()
    local tmux = require("tmux")
    local res = tmux.setup({
      disable_default_keybindings = true,
      navigation = {
        enable_default_keybindings = false,
        keybindings = {
          left = "<C-w>h",
          right = "<C-w>l",
          up = "<C-w>k",
          down = "<C-w>j",
        },
      },
      resize = {
        enable_default_keybindings = false,
      },
    })

    local set = vim.keymap.set
    set("n", "<C-w>h", tmux.move_left, { silent = true, desc = "Tmux/Nvim move left" })
    set("n", "<C-w>l", tmux.move_right, { silent = true, desc = "Tmux/Nvim move right" })
    set("n", "<C-w>j", tmux.move_bottom, { silent = true, desc = "Tmux/Nvim move down" })
    set("n", "<C-w>k", tmux.move_top, { silent = true, desc = "Tmux/Nvim move up" })

    return res
  end
}
