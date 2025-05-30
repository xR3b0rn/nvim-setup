local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local mason = require("mason")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local wk = require("which-key")

vim.opt.digraph = false

lsp.extend_lspconfig()
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  completion = {
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

mason.setup({})

lsp.on_attach(function(client, bufnr)
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
      { "<C-f>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format code" },
    }
  })
  wk.add({
    {
      mode   = "i",
      buffer = bufnr,
      { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature help" },
    }
  })
  local ls = require("lsp_signature")
  wk.add({
    {
      mode = "i",     -- Insert mode
      buffer = bufnr, -- Make it buffer-local
      noremap = true,
      silent = true,
      { "<C-k>", ls.toggle_float_win, desc = "Toggle LSP signature window" }
    }
  })

  ls.on_attach({
    bind = true,
    handler_opts = { border = "rounded" },
  }, bufnr)
end)


vim.diagnostic.config({
  virtual_text = true
})

lsp.configure("clangd", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--clang-tidy",
  },
  root_dir = function()
    return vim.fn.getcwd()
  end,
})
lsp.configure("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
  on_new_config = function(new_config, new_cwd)
    print("test")
    local status, cmake = pcall(require, "cmake-tools")
    if status then
      cmake.clangd_on_new_config(new_config)
    end
  end,
})
