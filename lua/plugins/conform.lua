return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        vhdl = { "vsg" },
      },
      formatters = {
        vsg = {
          command = vim.fn.stdpath("data") .. "/mason/bin/vsg",
          args = { "--fix", "--style", "indent_only", "$FILENAME" },
          stdin = false,
          exit_codes = { 0, 1 },
        },
      },
      lsp_fallback = true,
    })
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      conform.format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}
