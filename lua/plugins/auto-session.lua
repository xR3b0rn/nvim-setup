return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>fs", "<cmd>AutoSession search<CR>", desc = "Session search" },
  },
  opts = {
    load_on_setup = true,
    enabled = true,
    git_use_branch_name = true,
    git_auto_restore_on_branch_change = true,
    auto_save = true,
    auto_restore = true,
    lazy_support = true,
    picker = "telescope",
    session_lens = {
      load_on_setup = true,
    },
  },
}
