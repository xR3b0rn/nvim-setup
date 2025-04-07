vim.g.mapleader = " "

local ts = require('telescope.builtin')
local t = require('telescope')
t.load_extension('git_grep')
t.load_extension("live_grep_args")

local function live_grep_args()
  t.extensions.live_grep_args.live_grep_args { cwd = "%:p:h" }
end

local function live_grep()
  ts.live_grep { grep_open_file = true }
end

local diagnostics_str = '<cmd>lua vim.diagnostic.open_float()<CR>'

local wk = require("which-key")
wk.add({
  {
    mode = { "n" },
    { "<leader>pv", vim.cmd.Ex,        desc = "file exporer" },
    { "<leader>gg", vim.cmd.LazyGit,   desc = "LazyGit" },
    { "<leader>nv", vim.cmd.Navbuddy,  desc = "Navbuddy" },
    { "<leader>ff", ts.find_files,     desc = "find files" },
    { "<leader>fg", live_grep_args,    desc = "live grep args" },
    { "<leader>fo", live_grep,         desc = "live grep" },
    { "<leader>fb", ts.buffers,        desc = "buffers" },
    { "<leader>fh", ts.help_tags,      desc = "help tags" },
    { "<leader>fd", ts.diagnostics,    desc = "diagnostics" },
    { "<leader>ft", ts.treesitter,     desc = "treesitter" },
    { "<leader>fr", ts.lsp_references, desc = "references" },
    { "<leader>e",  diagnostics_str,   desc = "float diagnostics" },
  }
})

vim.cmd [[
  let g:netrw_fastbrowse = 2
  let g:netrw_preview = 1
  let g:mkdp_auto_start = 0
  nmap <silent> <c-k> :wincmd k<CR>
  nmap <silent> <c-j> :wincmd j<CR>
  nmap <silent> <c-h> :wincmd h<CR>
  nmap <silent> <c-l> :wincmd l<CR>
]]
