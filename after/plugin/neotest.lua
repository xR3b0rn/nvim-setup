local cmake = require("cmake-tools")
local neotest = require("neotest")
local overseer = require("overseer")

cmake.setup {
  cmake_executor={name="overseer", opts={ direction = "bottom" }},
}
if cmake.is_cmake_project() then
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.cpp", "*.cc", "*.cxx"},
    callback = function()
      cmake.build({target = "all"}, function(succ)
        if succ then
          overseer.toggle()
          neotest.run.run(vim.fn.expand("%"))
        end
      end)
    end,
  })
end
