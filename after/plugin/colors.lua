
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
  hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  hl.blend = 100
  hl.bg = "none"
	vim.api.nvim_set_hl(0, "Normal", hl)
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

--ColorMyPencils()

vim.opt.cursorline = true

