return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "stevearc/overseer.nvim"
  },
  config = function()
    local cmake = require("cmake-tools")
    local overseer = require("overseer")
    cmake.setup {
      cmake_executor = {
        name = "quickfix",
        default_opts = {
          toggleterm = {
            show                    = "only_on_error",
            position                = "bottom",
            auto_close_when_success = true,
          },
        },
      },
      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        refresh_rate_ms = 100,
      },
      cmake_virtual_text_support = true,
      -- Default is codelldb/LLDB, which reliably segfaults parsing DWARF
      -- for GCC-emitted STL types (this project builds with GCC). Match
      -- the gdb-based adapter used for plain debug launches in dap.lua.
      cmake_dap_configuration = {
        name = "cpp",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        stopAtEntry = false,
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

    -- cmake.debug() always builds first, even when only the BufWritePost
    -- autocmd below is skipped -- and that build uses this same "quickfix"
    -- executor with show="always". Opening the quickfix window while dapui
    -- is up permanently shrinks one of its docked panels (see
    -- lua/setup/quickfix.lua for why that can't be undone after the fact),
    -- so it's suppressed here at the source instead, for every build
    -- regardless of what triggered it.
    local qf_executor = require("cmake-tools.quickfix")
    local qf_executor_show = qf_executor.show
    qf_executor.show = function(opts)
      if require("dap_state").is_dap_active() then
        return
      end
      return qf_executor_show(opts)
    end

    if cmake.is_cmake_project() then
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.cpp", "*.cc", "*.cxx", "*.c", "*.h", "*.hpp" },
        callback = function()
          -- Building on every save doesn't affect the process already
          -- running under the debugger, and opening the quickfix window
          -- while dapui's docked panels are up visibly disturbs their
          -- layout (Vim shrinks them to make room and doesn't fully give
          -- that space back once the quickfix window closes again -- it
          -- compounds with every save). Skip the auto-build while
          -- debugging; save again once the session ends if needed.
          if require("dap_state").is_dap_active() then
            return
          end
          cmake.stop_executor()
          cmake.build({ target = "all" }, function(succ)
            if succ == true then
              overseer.toggle()
            end
          end)
        end,
      })
    end
  end,
}
