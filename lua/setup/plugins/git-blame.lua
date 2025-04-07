return {
    "f-person/git-blame.nvim",
    config = function()
        require("gitblame").setup({
            enabled = true,  -- enable the plugin
            message_template = " <summary> • <date> • <author> • <<sha>>",
            date_format = "%m-%d-%Y %H:%M:%S",
            virtual_text_column = 1,
        })
    end,
}
