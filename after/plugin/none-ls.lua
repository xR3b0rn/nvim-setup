local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.clang_format
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/rangeFormatting") then
      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = group,
        callback = function()
          local lsp_format_modifications = require("lsp-format-modifications")
          local succ = lsp_format_modifications.format_modifications(client, bufnr, { vcs = "localc" })
          if not success then
            vim.lsp.buf.format{bufnr = bufnr}
          end
        end,
        desc = "[lsp] format on save",
      })
    end
    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})
