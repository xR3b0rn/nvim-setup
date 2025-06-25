return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  requires = {
    { 'neovim/nvim-lspconfig' },
    {
      'williamboman/mason.nvim',
      run = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },
  }
}
