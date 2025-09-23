local dap = require("dap")
local wk = require("which-key")
local cmake = require("cmake-tools")

local cached_program = nil

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
      if not cached_program then
        cached_program = vim.fn.getcwd() .. '/'
      end
      cached_program = vim.fn.input('Path to executable: ', cached_program, 'file')
      return cached_program
    end,
    cwd = '${workspaceFolder}',
    args = {},
  },
  {
    name = "Attach to gdbserver",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = function()
      if not cached_ip then
        cached_ip = ":1234"
      end
      cached_ip = vim.fn.input('IP address of remote system: ', cached_ip, 'file')
      return cached_ip
    end,
    miDebuggerPath = "/usr/bin/gdb-multiarch",
    cwd = '${workspaceFolder}',
    program = function()
      if not cached_program then
        cached_program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end
      return cached_program
    end,
    stopAtEntry = true,
    externalConsole = false,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false
      }
    },
  }
}

dap.configurations.c = {
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Launch",
    type = "cppdbg", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = "launch",
    pid = require("dap.utils").launch,
    program = function()
      if not cached_program then
        cached_program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end
      return cached_program
    end,
    cwd = '${workspaceFolder}',
    args = {},
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
    { "<leader>dT", function() dap.terminate() end,                                                   desc = "terminate debug program" },
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
