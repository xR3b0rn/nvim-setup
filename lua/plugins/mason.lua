return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "stevearc/conform.nvim",
  },
  keys = {
    { "gD",          vim.lsp.buf.declaration,      desc = "Goto declaration",        mode = "n" },
    { "gd",          vim.lsp.buf.definition,       desc = "Goto definition",         mode = "n" },
    { "K",           vim.lsp.buf.hover,            desc = "Hover (show info)",       mode = "n" },
    { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Search workspace symbol", mode = "n" },
    { "<leader>vd",  vim.diagnostic.open_float,    desc = "Open diagnostics popup",  mode = "n" },
    { "[d",          vim.diagnostic.goto_prev,     desc = "Prev diagnostic",         mode = "n" },
    { "]d",          vim.diagnostic.goto_next,     desc = "Next diagnostic",         mode = "n" },
    { "<leader>vca", vim.lsp.buf.code_action,      desc = "Code action",             mode = "n" },
    { "<leader>vrr", vim.lsp.buf.references,       desc = "List references",         mode = "n" },
    { "<leader>vrn", vim.lsp.buf.rename,           desc = "Rename symbol",           mode = "n" },
    {
      "<C-f>",
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local has_formatter = false

        for _, client in ipairs(clients) do
          if client.server_capabilities.documentFormattingProvider then
            has_formatter = true
            break
          end
        end

        if has_formatter then
          vim.lsp.buf.format({ async = true })
        else
          require("conform").format({ async = true })
        end
      end,
      desc = "Format file",
      mode = "n"
    },
    { "<C-Space>", "<Cmd>lua vim.lsp.buf.completion()<CR>", desc = "Trigger completion", mode = "i" },
  },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }
}
