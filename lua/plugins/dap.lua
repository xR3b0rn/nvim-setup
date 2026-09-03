return {
  'mfussenegger/nvim-dap',
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    local dap = require("dap")
    local wk = require("which-key")
    local dap_args = require("dap_args")

    local cached_program = nil
    local cached_ip = nil

    -- gdb, not codelldb/LLDB: this project builds with GCC, and LLDB's DWARF
    -- parser reliably segfaults on GCC-emitted STL types (e.g. unique_ptr's
    -- `_M_t` member) -- gdb is the GNU toolchain's own debugger and doesn't
    -- have that problem.
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "/opt/debugAdapters/bin/OpenDebugAD7",
    }

    -- Static fallback configurations, always available regardless of
    -- project. nvim-dap automatically reads .vscode/launch.json (if present)
    -- and adds those on top every time dap.continue()/:DapNew runs -- no
    -- extra wiring needed here, see :h dap-launch.json.
    dap.configurations.cpp = {
      {
        name = "Launch (pick executable)",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        program = function()
          cached_program = vim.fn.input("Path to executable: ", cached_program or (vim.fn.getcwd() .. "/"), "file")
          return cached_program
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        externalConsole = false,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
        args = function()
          return dap_args.get()
        end,
      },
      {
        name = "Attach to gdbserver",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = function()
          cached_ip = vim.fn.input("IP address of remote system: ", cached_ip or ":1234")
          return cached_ip
        end,
        miDebuggerPath = "/usr/bin/gdb-multiarch",
        cwd = "${workspaceFolder}",
        args = function()
          return dap_args.get()
        end,
        program = function()
          cached_program = vim.fn.input("Path to the program: ", cached_program or (vim.fn.getcwd() .. "/"), "file")
          return cached_program
        end,
        stopAtEntry = true,
        externalConsole = false,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
    }
    dap.configurations.c = dap.configurations.cpp

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '⚪', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '🔵', texthl = '', linehl = '', numhl = '' })

    vim.keymap.set("n", "<F5>", function()
      if dap.session() then
        dap.continue()
        return
      end
      local ok, cmake = pcall(require, "cmake-tools")
      if ok and cmake.is_cmake_project() then
        vim.cmd("CMakeDebug")
      else
        dap.continue()
      end
    end)
    vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end)
    vim.keymap.set("n", "<F10>", function() dap.step_over() end)
    vim.keymap.set("n", "<F11>", function() dap.step_into() end)
    vim.keymap.set("n", "<F12>", function() dap.step_out() end)
    wk.add({
      {
        mode = { "n" },
        { "<leader>dT", function() dap.terminate() end,                                                   desc = "terminate debug program" },
        { "<leader>dp", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "set logging breakpoint" },
        { "<leader>dr", function() dap.repl.open() end,                                                   desc = "dap open repl" },
        { "<leader>dl", function() dap.run_last() end,                                                    desc = "run last" },
        { "<leader>dh", function() require('dap.ui.widgets').hover() end,                                 desc = "dap hover" },
        { "<leader>dP", function() require('dap.ui.widgets').preview() end,                               desc = "dap preview" },
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
  end,
}
