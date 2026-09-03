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
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    -- Catch-all: if the adapter process itself dies (crash, bad exit code,
    -- ...) the DAP "terminated"/"exited" events above never arrive, since
    -- those are protocol messages the (now-dead) adapter would have to
    -- send. Without this, dapui stays open and a retry stacks another set
    -- of panels on top instead of replacing the old one. on_session fires
    -- whenever no session remains, regardless of how it ended.
    dap.listeners.on_session.dapui_config = function(_, new_session)
      if not new_session then
        dapui.close()
      end
    end
  end,
}
