local M = {}

M.args = M.args or {}

function M.add(arg)
  if not arg or vim.trim(arg) == "" then
    return
  end
  table.insert(M.args, vim.trim(arg))
end

function M.clear()
  M.args = {}
end

function M.get()
  return vim.deepcopy(M.args)
end

function M.show()
  local snacks = require("snacks")

  if #M.args == 0 then
    vim.notify("No DAP arguments set.", vim.log.levels.INFO, {
      title = "DAP Args",
      id = "dap_args",
    })
    return
  end

  local lines = { "Current DAP arguments:" }
  for i, arg in ipairs(M.args) do
    lines[#lines + 1] = string.format("%2d. %s", i, arg)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "DAP Args",
    id = "dap_args",
    timeout = 8000,
  })
end

function M.add(arg)
  if not arg or vim.trim(arg) == "" then
    return
  end
  table.insert(M.args, vim.trim(arg))
end

function M.setup_commands()
  vim.api.nvim_create_user_command("ArgsAdd", function(opts)
    M.add(opts.args)
    vim.notify("Added DAP arg: " .. opts.args, vim.log.levels.INFO, {
      title = "DAP Args",
      id = "dap_args",
    })
  end, {
    nargs = 1,
    desc = "Add one DAP argument",
  })

  vim.api.nvim_create_user_command("ArgsClear", function()
    M.clear()
    vim.notify("DAP arguments cleared.", vim.log.levels.INFO, {
      title = "DAP Args",
      id = "dap_args",
    })
  end, {})

  vim.api.nvim_create_user_command("ArgsShow", function()
    M.show()
  end, {})
end

return M
