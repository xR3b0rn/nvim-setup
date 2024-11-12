-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  local lua_files = vim.fn.globpath("plugins", "*.lua", false, true)
  for _, file in ipairs(lua_files) do
    local mod2, _ = string.gsub(file, "/", ".")
    local len = #mod2
    local mod = string.sub(mod2, 1, len - 4)
    use(require(mod))
  end
end)
