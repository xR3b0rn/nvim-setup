return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local wk = require("which-key")
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()
    wk.add({
      {
        mode = { "n" },
        { "<leader>dt", dapui.toggle, desc = "toggle dap-ui" }
      }
    })
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.toggle()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.toggle()
    end
  end,
}
