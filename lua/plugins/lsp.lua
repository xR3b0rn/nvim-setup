return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "pyright" }, -- passe deine Server an
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- vim.lsp.config.enable("lua_ls")
      -- vim.lsp.config.enable("clangd")
      -- vim.lsp.config.enable("pyright")
    end,
  },
}
