vim.o.mouse = 'a'
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

vim.opt.list = true

vim.opt.cursorline = true

function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
  hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  hl.blend = 100
  hl.bg = "none"
	vim.api.nvim_set_hl(0, "Normal", hl)
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end
