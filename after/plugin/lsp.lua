local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

vim.opt.digraph = false

lsp.on_attach(function(client, bufnr)
  local wk = require("which-key")
  wk.register({
    gD              = { vim.lsp.buf.declaration, "Goto declaration" },
    gd              = { vim.lsp.buf.definition, "Goto definition" },
    K               = { vim.lsp.buf.hover, "Hover" },
    ["<leader>vws"] = { vim.lsp.buf.workspace_symbol, "Workspace symbol" },
    ["<leader>vd"]  = { vim.diagnostic.open_float, "Open float" },
    ["[d"]          = { vim.diagnostic.goto_next, "Next diagnostic" },
    ["]d"]          = { vim.diagnostic.goto_prev, "Prev diagnostic" },
    ["<leader>vca"] = { vim.lsp.buf.code_action, "Code action" },
    ["<leader>vrr"] = { vim.lsp.buf.references, "List references" },
    ["<leader>vrn"] = { vim.lsp.buf.rename, "Rename symbol" },
  }, {
    mode   = "n",
    buffer = bufnr, -- Make sure the mapping is buffer-local to the LSP buffer
  })
  wk.register({
    ["<C-F>"] = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format code" },
  }, {
    mode   = { "n", "v" },
    buffer = bufnr,
  })
  wk.register({
    ["<C-h>"] = { vim.lsp.buf.signature_help, "Signature help" },
  }, {
    mode   = "i",
    buffer = bufnr,
  })
  wk.register({
    ["<C-k>"] = {
      function()
        require("lsp_signature").toggle_float_win()
      end,
      "Toggle LSP signature window",
    },
  }, {
    mode = "i",   -- Insert mode
    buffer = bufnr, -- Make it buffer-local
    noremap = true,
    silent = true,
  })

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = { border = "rounded" },
  }, bufnr)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

local cmp_nvim_lsp = require "cmp_nvim_lsp"

require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--clang-tidy",
  },
  root_dir = function()
    return vim.fn.getcwd()
  end,
}
