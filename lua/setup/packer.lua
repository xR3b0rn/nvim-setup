-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  if packer_bootstrap then
    require('packer').sync()
  end
  local lua_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/setup/plugins", "*.lua", false, true)
  for _, file in ipairs(lua_files) do
    file = string.gsub(file, vim.fn.stdpath("config") .. "/lua/", "")
    local mod2, _ = string.gsub(file, "/", ".")
    local len = #mod2
    local mod = string.sub(mod2, 1, len - 4)
    use(require(mod))
  end
end)
