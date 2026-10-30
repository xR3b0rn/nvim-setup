-- zsh for :terminal, :!, toggleterm and the cmake build terminal, regardless
-- of $SHELL. Set before lazy so plugins pick it up when they load.
if vim.fn.executable("zsh") == 1 then
  vim.o.shell = vim.fn.exepath("zsh")
end

require("config.lazy")
require("setup")
