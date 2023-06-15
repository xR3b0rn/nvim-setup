vim.g.cmake_vimspector_support = 1
vim.g.cmake_vimspector_default_configuration = {
  adapter = "vscode-cpptools",
  configuration = {
    request = "launch",
    cwd = "${workspaceRoot}",
    Mimode = "",
    args = {},
    program = ""
  }
}
