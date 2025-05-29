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
}

if cmake.is_cmake_project() then
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.cpp", "*.cc", "*.cxx", "*.c", "*.h", "*.hpp" },
    callback = function()
      cmake.build({ target = "all" }, function(succ)
        if succ == true then
          overseer.toggle()
        end
      end)
    end,
  })
end
