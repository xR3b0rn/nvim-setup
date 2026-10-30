return {
  "akinsho/toggleterm.nvim",
  config = function()
    local tt = require("toggleterm")
    tt.setup {
      open_mapping = [[<c-\>]],
      direction    = "float",
    }

    -- The cmake "build" terminal (lua/build_term.lua) is hidden, so <c-\>
    -- never opens or closes it. But toggleterm still counts its open window
    -- as "a terminal is open" and would then try to close terminals instead
    -- of opening one -- doing nothing at all. Ignore the build window here.
    local toggle = tt.toggle
    tt.toggle = function(count, size, dir, direction, name)
      if (not count or count < 1) and not require("build_term").other_terminal_open() then
        local ui = require("toggleterm.ui")
        if ui.open_terminal_view(size, direction) then
          return
        end
        count = require("toggleterm.terminal").get_toggled_id() or 1
      end
      return toggle(count, size, dir, direction, name)
    end
  end,
}
