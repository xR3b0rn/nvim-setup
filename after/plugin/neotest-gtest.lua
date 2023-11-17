local utils = require("neotest-gtest.utils")
local lib = require("neotest.lib")

require("neotest-gtest").setup({
  -- dap.adapters.<this debug_adapter> must be set for debugging to work
  -- see "installation" section above for installing and setting it up
  debug_adapter = "codelldb",

  -- Must be set to a function that takes a single string argument (full path to file)
  -- and returns its root. `neotest` provides a utility match_root_pattern,
  -- which will return the first parent directory containing one of these file names
  root = lib.files.match_root_pattern(
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    "init.lua",
    "init.vim",
    "build",
    ".git"
  ),

  -- takes full path to the file and returns true if it's a test file, false otherwise
  -- by default, returns true for all cpp files starting with "test_" or ending with
  -- "_test"
  is_test_file = utils.is_test_file
})
