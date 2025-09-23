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
      local mason = require("mason")
      local wk = require("which-key")
      local cmp = require('cmp')
      local ls = require("lsp_signature")

      mason.setup({})

      vim.opt.digraph = false

      vim.lsp.enable("clangd")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("cmake-language-server")

      cmp.setup({
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-space>'] = cmp.mapping.complete(),
        },
        completion = {
          autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      })

      vim.diagnostic.config({
        virtual_text = true
      })

      local on_attach = function(client, bufnr)
        wk.add({
          {
            mode = "n",
            buffer = bufnr,
            { "gD",          vim.lsp.buf.declaration,      desc = "Goto declaration" },
            { "gd",          vim.lsp.buf.definition,       desc = "Goto definition" },
            { "K",           vim.lsp.buf.hover,            desc = "Hover" },
            { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Workspace symbol" },
            { "<leader>vd",  vim.diagnostic.open_float,    desc = "Open float" },
            { "[d",          vim.diagnostic.goto_next,     desc = "Next diagnostic" },
            { "]d",          vim.diagnostic.goto_prev,     desc = "Prev diagnostic" },
            { "<leader>vca", vim.lsp.buf.code_action,      desc = "Code action" },
            { "<leader>vrr", vim.lsp.buf.references,       desc = "List references" },
            { "<leader>vrn", vim.lsp.buf.rename,           desc = "Rename symbol" },
          }
        })
        wk.add({
          {
            mode   = { "n", "v" },
            buffer = bufnr,
            {
              "<C-f>",
              function()
                vim.lsp.buf.format({ async = true })
              end,
              desc = "Format code"
            },
          }
        })
        wk.add({
          {
            mode   = "i",
            buffer = bufnr,
            { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature help" },
          }
        })
        wk.add({
          {
            mode = "i",
            buffer = bufnr,
            noremap = true,
            silent = true,
            { "<C-k>", ls.toggle_float_win, desc = "Toggle LSP signature window" }
          }
        })
        ls.on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
        }, bufnr)

        if client.supports_method("textDocument/rangeFormatting") then
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = group,
            callback = function()
            end,
            desc = "[lsp] format on save",
          })
        end
      end

      vim.lsp.config("clangd", {
        on_attach = on_attach
      })

      vim.lsp.config("lua_ls", {
        on_attach = on_attach
      })

      vim.lsp.config("rust_analyzer", {
        on_attach = on_attach
      })
    end,
  },
}
