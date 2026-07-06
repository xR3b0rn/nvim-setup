return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    require("gp").setup({
      debug = false,
      openai_api_key = os.getenv("OPENAI_API_KEY"),
      agents = {
        {
          name = "gpt-5.1",
          chat = true,
          command = true,
          model = { model = "gpt-5.2", temperature = 0.7, top_p = 1 },
          system_prompt = "GPT-5.2.",
        },
      },

      default_chat_agent = "gpt-5.1",
      default_command_agent = "gpt-5.1",
    })
  end,

  keys = {
    ----------------------------------------------------------------------
    -- VISUAL mode
    ----------------------------------------------------------------------
    { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", mode = "v",                   desc = "ChatNew tabnew" },
    { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", mode = "v",                   desc = "ChatNew vsplit" },
    { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>",  mode = "v",                   desc = "ChatNew split" },

    { "<C-g>a",     ":<C-u>'<,'>GpAppend<cr>",         mode = "v",                   desc = "Visual Append (after)" },
    { "<C-g>b",     ":<C-u>'<,'>GpPrepend<cr>",        mode = "v",                   desc = "Visual Prepend (before)" },
    { "<C-g>c",     ":<C-u>'<,'>GpChatNew<cr>",        mode = "v",                   desc = "Visual Chat New" },

    { "<C-g>g",     mode = "v",                        desc = "generate into new .." },
    { "<C-g>ge",    ":<C-u>'<,'>GpEnew<cr>",           mode = "v",                   desc = "Visual GpEnew" },
    { "<C-g>gn",    ":<C-u>'<,'>GpNew<cr>",            mode = "v",                   desc = "Visual GpNew" },
    { "<C-g>gp",    ":<C-u>'<,'>GpPopup<cr>",          mode = "v",                   desc = "Visual Popup" },
    { "<C-g>gt",    ":<C-u>'<,'>GpTabnew<cr>",         mode = "v",                   desc = "Visual GpTabnew" },
    { "<C-g>gv",    ":<C-u>'<,'>GpVnew<cr>",           mode = "v",                   desc = "Visual GpVnew" },

    { "<C-g>i",     ":<C-u>'<,'>GpImplement<cr>",      mode = "v",                   desc = "Implement selection" },
    { "<C-g>n",     "<cmd>GpNextAgent<cr>",            mode = "v",                   desc = "Next Agent" },
    { "<C-g>l",     "<cmd>GpSelectAgent<cr>",          mode = "v",                   desc = "Select Agent" },
    { "<C-g>p",     ":<C-u>'<,'>GpChatPaste<cr>",      mode = "v",                   desc = "Visual Chat Paste" },
    { "<C-g>r",     ":<C-u>'<,'>GpRewrite<cr>",        mode = "v",                   desc = "Visual Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",                 mode = "v",                   desc = "GpStop" },
    { "<C-g>t",     ":<C-u>'<,'>GpChatToggle<cr>",     mode = "v",                   desc = "Visual Toggle Chat" },

    -- Whisper (visual)
    { "<C-g>w",     mode = "v",                        desc = "Whisper" },
    { "<C-g>wa",    ":<C-u>'<,'>GpWhisperAppend<cr>",  mode = "v",                   desc = "Whisper Append" },
    { "<C-g>wb",    ":<C-u>'<,'>GpWhisperPrepend<cr>", mode = "v",                   desc = "Whisper Prepend" },
    { "<C-g>we",    ":<C-u>'<,'>GpWhisperEnew<cr>",    mode = "v",                   desc = "Whisper Enew" },
    { "<C-g>wn",    ":<C-u>'<,'>GpWhisperNew<cr>",     mode = "v",                   desc = "Whisper New" },
    { "<C-g>wp",    ":<C-u>'<,'>GpWhisperPopup<cr>",   mode = "v",                   desc = "Whisper Popup" },
    { "<C-g>wr",    ":<C-u>'<,'>GpWhisperRewrite<cr>", mode = "v",                   desc = "Whisper Rewrite" },
    { "<C-g>wt",    ":<C-u>'<,'>GpWhisperTabnew<cr>",  mode = "v",                   desc = "Whisper Tabnew" },
    { "<C-g>wv",    ":<C-u>'<,'>GpWhisperVnew<cr>",    mode = "v",                   desc = "Whisper Vnew" },
    { "<C-g>ww",    ":<C-u>'<,'>GpWhisper<cr>",        mode = "v",                   desc = "Whisper" },

    { "<C-g>x",     ":<C-u>'<,'>GpContext<cr>",        mode = "v",                   desc = "Visual GpContext" },

    ----------------------------------------------------------------------
    -- NORMAL mode
    ----------------------------------------------------------------------
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",       mode = "n",                   desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",       mode = "n",                   desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",        mode = "n",                   desc = "New Chat split" },

    { "<C-g>a",     "<cmd>GpAppend<cr>",               mode = "n",                   desc = "Append (after)" },
    { "<C-g>b",     "<cmd>GpPrepend<cr>",              mode = "n",                   desc = "Prepend (before)" },
    { "<C-g>c",     "<cmd>GpChatNew<cr>",              mode = "n",                   desc = "New Chat" },
    { "<C-g>f",     "<cmd>GpChatFinder<cr>",           mode = "n",                   desc = "Chat Finder" },

    { "<C-g>g",     mode = "n",                        desc = "generate into new .." },
    { "<C-g>ge",    "<cmd>GpEnew<cr>",                 mode = "n",                   desc = "GpEnew" },
    { "<C-g>gn",    "<cmd>GpNew<cr>",                  mode = "n",                   desc = "GpNew" },
    { "<C-g>gp",    "<cmd>GpPopup<cr>",                mode = "n",                   desc = "Popup" },
    { "<C-g>gt",    "<cmd>GpTabnew<cr>",               mode = "n",                   desc = "GpTabnew" },
    { "<C-g>gv",    "<cmd>GpVnew<cr>",                 mode = "n",                   desc = "GpVnew" },

    { "<C-g>n",     "<cmd>GpNextAgent<cr>",            mode = "n",                   desc = "Next Agent" },
    { "<C-g>l",     "<cmd>GpSelectAgent<cr>",          mode = "n",                   desc = "Select Agent" },
    { "<C-g>r",     "<cmd>GpRewrite<cr>",              mode = "n",                   desc = "Inline Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",                 mode = "n",                   desc = "GpStop" },
    { "<C-g>t",     "<cmd>GpChatToggle<cr>",           mode = "n",                   desc = "Toggle Chat" },

    -- Whisper (normal)
    { "<C-g>w",     mode = "n",                        desc = "Whisper" },
    { "<C-g>wa",    "<cmd>GpWhisperAppend<cr>",        mode = "n",                   desc = "Whisper Append" },
    { "<C-g>wb",    "<cmd>GpWhisperPrepend<cr>",       mode = "n",                   desc = "Whisper Prepend" },
    { "<C-g>we",    "<cmd>GpWhisperEnew<cr>",          mode = "n",                   desc = "Whisper Enew" },
    { "<C-g>wn",    "<cmd>GpWhisperNew<cr>",           mode = "n",                   desc = "Whisper New" },
    { "<C-g>wp",    "<cmd>GpWhisperPopup<cr>",         mode = "n",                   desc = "Whisper Popup" },
    { "<C-g>wr",    "<cmd>GpWhisperRewrite<cr>",       mode = "n",                   desc = "Whisper Rewrite" },
    { "<C-g>wt",    "<cmd>GpWhisperTabnew<cr>",        mode = "n",                   desc = "Whisper Tabnew" },
    { "<C-g>wv",    "<cmd>GpWhisperVnew<cr>",          mode = "n",                   desc = "Whisper Vnew" },
    { "<C-g>ww",    "<cmd>GpWhisper<cr>",              mode = "n",                   desc = "Whisper" },

    { "<C-g>x",     "<cmd>GpContext<cr>",              mode = "n",                   desc = "Toggle GpContext" },

    ----------------------------------------------------------------------
    -- INSERT mode
    ----------------------------------------------------------------------
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",       mode = "i",                   desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",       mode = "i",                   desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",        mode = "i",                   desc = "New Chat split" },

    { "<C-g>a",     "<cmd>GpAppend<cr>",               mode = "i",                   desc = "Append (after)" },
    { "<C-g>b",     "<cmd>GpPrepend<cr>",              mode = "i",                   desc = "Prepend (before)" },
    { "<C-g>c",     "<cmd>GpChatNew<cr>",              mode = "i",                   desc = "New Chat" },
    { "<C-g>f",     "<cmd>GpChatFinder<cr>",           mode = "i",                   desc = "Chat Finder" },

    { "<C-g>g",     mode = "i",                        desc = "generate into new .." },
    { "<C-g>ge",    "<cmd>GpEnew<cr>",                 mode = "i",                   desc = "GpEnew" },
    { "<C-g>gn",    "<cmd>GpNew<cr>",                  mode = "i",                   desc = "GpNew" },
    { "<C-g>gp",    "<cmd>GpPopup<cr>",                mode = "i",                   desc = "Popup" },
    { "<C-g>gt",    "<cmd>GpTabnew<cr>",               mode = "i",                   desc = "GpTabnew" },
    { "<C-g>gv",    "<cmd>GpVnew<cr>",                 mode = "i",                   desc = "GpVnew" },

    { "<C-g>n",     "<cmd>GpNextAgent<cr>",            mode = "i",                   desc = "Next Agent" },
    { "<C-g>l",     "<cmd>GpSelectAgent<cr>",          mode = "i",                   desc = "Select Agent" },
    { "<C-g>r",     "<cmd>GpRewrite<cr>",              mode = "i",                   desc = "Inline Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",                 mode = "i",                   desc = "GpStop" },
    { "<C-g>t",     "<cmd>GpChatToggle<cr>",           mode = "i",                   desc = "Toggle Chat" },

    -- Whisper (insert)
    { "<C-g>w",     mode = "i",                        desc = "Whisper" },
    { "<C-g>wa",    "<cmd>GpWhisperAppend<cr>",        mode = "i",                   desc = "Whisper Append" },
    { "<C-g>wb",    "<cmd>GpWhisperPrepend<cr>",       mode = "i",                   desc = "Whisper Prepend" },
    { "<C-g>we",    "<cmd>GpWhisperEnew<cr>",          mode = "i",                   desc = "Whisper Enew" },
    { "<C-g>wn",    "<cmd>GpWhisperNew<cr>",           mode = "i",                   desc = "Whisper New" },
    { "<C-g>wp",    "<cmd>GpWhisperPopup<cr>",         mode = "i",                   desc = "Whisper Popup" },
    { "<C-g>wr",    "<cmd>GpWhisperRewrite<cr>",       mode = "i",                   desc = "Whisper Rewrite" },
    { "<C-g>wt",    "<cmd>GpWhisperTabnew<cr>",        mode = "i",                   desc = "Whisper Tabnew" },
    { "<C-g>wv",    "<cmd>GpWhisperVnew<cr>",          mode = "i",                   desc = "Whisper Vnew" },
    { "<C-g>ww",    "<cmd>GpWhisper<cr>",              mode = "i",                   desc = "Whisper" },

    { "<C-g>x",     "<cmd>GpContext<cr>",              mode = "i",                   desc = "Toggle GpContext" },
  },
}
