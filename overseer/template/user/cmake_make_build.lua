return {
  name = "cmake make build",
  builder = function()
    return {
      cmd = { "make" },
      args = { "-j$(nproc)" },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
