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

    -- gdb, not codelldb/LLDB: this project builds with GCC, and LLDB's DWARF parser reliably segfaults on GCC-emitted STL types (e.g. unique_ptr's
    -- `_M_t` member) -- gdb is the GNU toolchain's own debugger and doesn't
    -- have that problem.
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "/opt/debugAdapters/OpenDebugAD7",
    }

    -- DEBUG also logs all adapter messages (incl. J-Link server and gdb
    -- output) to :DapShowLog, which survives the session closing.
    dap.set_log_level("DEBUG")

    -- Zephyr on the nRF5340 via J-Link (values from the project's
    -- app/build/app/zephyr/runners.yaml).
    local zephyr = {
      config_name = "Zephyr JTAG (Build, Flash & Debug)",
      build_dir = "app/build",
      jlink_server = "/usr/bin/JLinkGDBServerCLExe",
      jlink_device = "nrf5340_xxaa_app",
      jlink_port = 2331,
    }

    local function zephyr_notify(msg, level)
      vim.notify(msg, level or vim.log.levels.INFO, { title = "Zephyr JTAG" })
    end

    -- Builds and checks the prerequisites before the adapter starts, and
    -- returns the ELF path. nvim-dap evaluates config functions inside a
    -- coroutine and waits for a returned thread, so the build runs without
    -- blocking the UI; resuming with dap.ABORT cancels the launch.
    local function zephyr_prepare()
      return coroutine.create(function(dap_co)
        local function finish(result)
          vim.schedule(function() coroutine.resume(dap_co, result) end)
        end
        local build_dir = vim.fn.getcwd() .. "/" .. zephyr.build_dir
        if vim.fn.isdirectory(build_dir) == 0 then
          zephyr_notify("Build directory missing: " .. build_dir, vim.log.levels.ERROR)
          return finish(dap.ABORT)
        end
        -- The probe can only be used by one server; a leftover one makes
        -- the new server exit immediately.
        local running = vim.system({ "pgrep", "-a", "JLinkGDBServer" }, { text = true }):wait()
        if running.code == 0 then
          zephyr_notify("A J-Link GDB server is already running, please stop it first:\n" .. running.stdout, vim.log.levels.ERROR)
          return finish(dap.ABORT)
        end
        zephyr_notify("Building " .. zephyr.build_dir .. " …")
        vim.system({ "cmake", "--build", build_dir }, { text = true }, function(res)
          vim.schedule(function()
            if res.code ~= 0 then
              local lines = vim.split(res.stdout .. res.stderr, "\n", { trimempty = true })
              vim.fn.setqflist({}, " ", { title = "Zephyr build", lines = lines })
              vim.cmd("copen")
              zephyr_notify("Build failed, see quickfix list", vim.log.levels.ERROR)
              return finish(dap.ABORT)
            end
            zephyr_notify("Build ok, starting J-Link GDB server …")
            finish(build_dir .. "/app/zephyr/zephyr.elf")
          end)
        end)
      end)
    end

    dap.listeners.after.launch.zephyr_jtag = function(session, err)
      if session.config.name ~= zephyr.config_name then
        return
      end
      if err then
        zephyr_notify("Launch failed: " .. tostring(err.message or err) ..
          "\nServer/GDB output: dap REPL (<leader>dr), log: :DapShowLog", vim.log.levels.ERROR)
      else
        zephyr_notify("Flashed merged.hex and reset, target running")
      end
    end

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
      {
        name = zephyr.config_name,
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb-multiarch",
        cwd = "${workspaceFolder}",
        program = zephyr_prepare,
        -- After the reset the core sits at MCUboot's reset vector (no symbols
        -- in zephyr.elf); an entry stop there is useless, so just run and
        -- let the user's breakpoints do the stopping.
        stopAtEntry = false,
        externalConsole = false,
        -- cppdbg starts the J-Link GDB server itself, waits for its
        -- "ready" line and then connects gdb to it. Both filter* options
        -- also forward the server's output to the dap console/REPL.
        debugServerPath = zephyr.jlink_server,
        debugServerArgs = string.format(
          "-device %s -if SWD -speed 4000 -port %d -nogui -singlerun",
          zephyr.jlink_device, zephyr.jlink_port),
        -- Not "Waiting for GDB connection": J-Link prints that without a
        -- trailing newline, and cppdbg only matches complete lines. The
        -- server is already listening once the target is connected.
        serverStarted = "Connected to target",
        serverLaunchTimeout = 20000,
        filterStdout = true,
        filterStderr = true,
        miDebuggerServerAddress = "localhost:" .. zephyr.jlink_port,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
        -- MCUboot only boots signed images, so flash merged.hex (MCUboot +
        -- signed app) instead of the unsigned zephyr.elf. gdb programs the
        -- flash via the J-Link server (its `monitor loadfile` is J-Link
        -- Commander only).
        -- zephyr.elf is still used for the symbols.
        postRemoteConnectCommands = {
          {
            text = "load ${workspaceFolder}/" .. zephyr.build_dir .. "/merged.hex",
            description = "flash merged.hex",
            ignoreFailures = false,
          },
          {
            text = "monitor reset",
            description = "reset and halt the target",
            ignoreFailures = false,
          },
        },
        logging = {
          programOutput = true,
          exceptions = true,
          engineLogging = true,
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
        local orig_select = vim.ui.select
        vim.ui.select = function(items, opts, on_choice)
          vim.ui.select = orig_select
          orig_select(items, opts, function(choice, idx)
            on_choice(choice, idx)
            if choice then
              vim.schedule(function()
                vim.cmd("CMakeDebug")
              end)
            end
          end)
        end
        vim.defer_fn(function()
          if vim.ui.select ~= orig_select then
            vim.ui.select = orig_select
          end
        end, 1000)
        vim.cmd("CMakeSelectLaunchTarget")
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
