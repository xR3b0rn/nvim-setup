return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "stevearc/overseer.nvim"
  },
  config = function()
    local cmake = require("cmake-tools")
    local overseer = require("overseer")
    -- must exist before setup(), which checks the executor is installed
    require("cmake-tools.executors").build = require("build_term")
    cmake.setup {
      -- -j$(nproc)
      cmake_build_options = { "-j", tostring(vim.uv.available_parallelism()) },
      -- "build" is our own toggleterm-based executor (lua/build_term.lua),
      -- registered above. Builds always run in the background; the opts only
      -- apply when the output is opened by hand (:CMakeOpenExecutor).
      cmake_executor = {
        name = "build",
        opts = {},
        default_opts = {
          build = {
            direction = "horizontal",
            size      = 12,
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

    -- Alt+\ next to toggleterm's <c-\>: build output as a float
    vim.keymap.set({ "n", "i", "t" }, "<M-\\>", function()
      vim.cmd("stopinsert")
      require("build_term").toggle("float")
    end, { silent = true, desc = "Toggle build output (float)" })

    if cmake.is_cmake_project() then
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.cpp", "*.cc", "*.cxx", "*.c", "*.h", "*.hpp" },
        callback = function()
          -- Also runs while debugging: the build happens in the background
          -- (lua/build_term.lua) and never opens a window, so dapui's
          -- layout isn't disturbed.
          cmake.stop_executor()
          cmake.build({ target = "all" }, function(succ)
            -- a docked split would disturb dapui's layout
            if succ == true and not require("dap_state").is_dap_active() then
              overseer.toggle()
            end
          end)
        end,
      })
    end
  end,
}
