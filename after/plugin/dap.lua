local dap = require("dap")
local wk = require("which-key")

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "/opt/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.cpp = {
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Launch",
    type = "cppdbg", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = "launch",
    pid = require("dap.utils").launch,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    args = {},
    preLaunchTask = "make"
  },
}

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '⚪', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '🔵', texthl = '', linehl = '', numhl = '' })

vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)

wk.add({
  {
    mode = { "n" },
    { "<leader>dT", function() dap.terminate() end, desc = "terminate debug program" },
    { "<leader>dp", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "set loggin breakpoint" },
    { "<leader>dr", function() dap.repl.open() end,                                                   desc = "dap open repl" },
    { "<leader>dl", function() dap.run_last() end,                                                    desc = "run last" },
    { "<leader>dh", function() require('dap.ui.widgets').hover() end,                                 desc = "dap hover" },
    { "<leader>dp", function() require('dap.ui.widgets').preview() end,                               desc = "dap preview" },
    {
      "<leader>df",
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end,
      desc = "dap centred float fames"
    },
    {
      "<Leader>ds",
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end,
      desc = "dap centred float scope"
    },
  }
})
