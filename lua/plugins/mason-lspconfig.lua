return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  -- explicit config (instead of `opts`) so mason.nvim's own setup (which
  -- adds its installed servers' bin dir to $PATH) has definitely already
  -- run before mason-lspconfig tries to auto-enable them -- otherwise
  -- lspconfig can't find the server binaries and LSP silently never
  -- attaches. mason.setup() is not idempotent-guarded, so calling it here
  -- with no opts is safe: mason.lua's own opts-driven setup still applies
  -- its icon config whenever lazy.nvim loads that plugin.
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "clangd"
      },
    })
  end,
}
