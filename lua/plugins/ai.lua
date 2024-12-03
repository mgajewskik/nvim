return {
   -- {
   --    "github/copilot.vim",
   --    event = "VeryLazy",
   --    enabled = true,
   --    config = function()
   --       vim.g.copilot_no_mappings = 1
   --       vim.g.copilot_no_tab_map = 1
   --       vim.g.copilot_no_tab_map = true
   --       vim.g.copilot_filetypes = {
   --          python = 0,
   --          go = 0,
   --          lua = 1,
   --          terraform = 1,
   --          yaml = 1,
   --          json = 1,
   --          bash = 1,
   --       }
   --       -- vim.g.copilot_filetypes = { yaml = "v:true" }
   --       vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
   --       vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { silent = true, expr = true })
   --       vim.api.nvim_set_keymap("i", "<C-L>", "copilot#Next()", { silent = true, expr = true })
   --    end,
   -- },
   {
      "supermaven-inc/supermaven-nvim",
      config = function()
         require("supermaven-nvim").setup({
            keymaps = {
               accept_suggestion = "<C-j>",
               accept_word = "<C-l>",
            },
         })
      end,
   },
   {
      "olimorris/codecompanion.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         -- The following are optional:
         { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
      },
      keys = {
         { "<C-f>", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true } },
         -- { "ga", "<cmd>CodeCompanionChat Add<cr>", { mode = "v", noremap = true, silent = true } },
      },
      -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      -- https://github.com/oca159/lazyvim/blob/main/lua/plugins/codecompanion.lua
      opts = {
         display = {
            chat = {
               render_headers = false, -- Use RenderMarkdown instead
            },
         },
         strategies = {
            chat = {
               adapter = "anthropic",
               slash_commands = {
                  ["buffer"] = {
                     opts = {
                        provider = "fzf_lua",
                     },
                  },
                  ["file"] = {
                     opts = {
                        provider = "fzf_lua",
                     },
                  },
                  ["help"] = {
                     opts = {
                        provider = "fzf_lua",
                     },
                  },
                  ["symbols"] = {
                     opts = {
                        provider = "fzf_lua",
                     },
                  },
               },
            },
            inline = {
               adapter = "anthropic",
            },
            cmd = {
               adapter = "anthropic",
            },
         },
      },
   },
   -- {
   --    "CopilotC-Nvim/CopilotChat.nvim",
   --    branch = "canary",
   --    dependencies = {
   --       -- { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
   --       { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
   --    },
   --    keys = {
   --       { "<C-f>", ":CopilotChatToggle<CR>", { noremap = true, silent = true } },
   --    },
   --    opts = {
   --       debug = false, -- Enable debugging
   --       show_help = false,
   --       model = "gpt-4",
   --       -- window = {
   --       --    layout = "float",
   --       --    width = 0.7,
   --       --    height = 0.7,
   --       --    border = "rounded",
   --       -- },
   --    },
   --    -- See Commands section for default commands if you want to lazy load on them
   -- },
   -- {
   --    "yetone/avante.nvim",
   --    event = "VeryLazy",
   --    lazy = false,
   --    keys = {
   --       { "<C-f>", ":AvanteToggle<CR>", { noremap = true, silent = true } },
   --    },
   --    opts = {
   --       -- windows = {
   --       --    ask = {
   --       --       floating = true,
   --       --    },
   --       -- },
   --    },
   --    build = "make",
   --    dependencies = {
   --       "nvim-treesitter/nvim-treesitter",
   --       "stevearc/dressing.nvim",
   --       "nvim-lua/plenary.nvim",
   --       "MunifTanjim/nui.nvim",
   --       --- The below dependencies are optional,
   --       "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
   --       -- "zbirenbaum/copilot.lua", -- for providers='copilot'
   --       {
   --          -- Make sure to set this up properly if you have lazy=true
   --          "MeanderingProgrammer/render-markdown.nvim",
   --          opts = {
   --             file_types = { "markdown", "Avante", "telekasten" },
   --             -- sign = {
   --             --    enabled = false,
   --             -- },
   --             -- heading = {
   --             --    sign = false,
   --             -- },
   --             -- code = {
   --             --    sign = false,
   --             -- },
   --          },
   --          ft = { "markdown", "Avante", "telekasten" },
   --       },
   --    },
   -- },
   -- {
   --    "Exafunction/codeium.vim",
   --    event = "BufEnter",
   --    enabled = false,
   --    config = function()
   --       vim.g.codeium_disable_bindings = 1
   --       vim.g.codeium_workspace_root_hints = { ".bzr", ".git", ".hg", ".svn", "_FOSSIL_", "package.json" }
   --
   --       vim.keymap.set("i", "<C-J>", function()
   --          return vim.fn["codeium#Accept"]()
   --       end, { expr = true, silent = true })
   --       vim.keymap.set("i", "<C-H>", function()
   --          return vim.fn["codeium#CycleCompletions"](1)
   --       end, { expr = true, silent = true })
   --       vim.keymap.set("i", "<C-L>", function()
   --          return vim.fn["codeium#CycleCompletions"](-1)
   --       end, { expr = true, silent = true })
   --
   --       -- to use the chat use: :call codeium#Chat()
   --       -- vim.keymap.set("i", "<C-N>", function()
   --       --    return vim.fn["codeium#Chat"]()
   --       -- end, { expr = true, silent = true })
   --       -- vim.keymap.set("i", "<c-x>", function()
   --       --    return vim.fn["codeium#Clear"]()
   --       -- end, { expr = true, silent = true })
   --    end,
   -- },
   -- {
   --    "MunifTanjim/nui.nvim",
   -- },
   -- {
   --    -- TODO to remove in the future
   --    "Bryley/neoai.nvim",
   --    dependencies = {
   --       "MunifTanjim/nui.nvim",
   --    },
   --    cmd = {
   --       "NeoAI",
   --       "NeoAIOpen",
   --       "NeoAIClose",
   --       "NeoAIToggle",
   --       "NeoAIContext",
   --       "NeoAIContextOpen",
   --       "NeoAIContextClose",
   --       "NeoAIInject",
   --       "NeoAIInjectCode",
   --       "NeoAIInjectContext",
   --       "NeoAIInjectContextCode",
   --    },
   --    keys = {
   --       { "<leader>as", desc = "summarize text" },
   --       { "<leader>ag", desc = "generate git message" },
   --       { "<leader>sa", ":NeoAI<CR>", { noremap = true, silent = true } },
   --    },
   --    config = function()
   --       require("neoai").setup({
   --          -- Options go here
   --       })
   --    end,
   -- },
   -- {
   --    "jackMort/ChatGPT.nvim",
   --    requires = {
   --       -- for some reason does not get installed from here
   --       "MunifTanjim/nui.nvim",
   --       "nvim-lua/plenary.nvim",
   --       "nvim-telescope/telescope.nvim",
   --    },
   --    lazy = true,
   --    cmd = { "ChatGPT" },
   --    keys = {
   --       { "<leader>sa", ":ChatGPT<CR>", { noremap = true, silent = true } },
   --    },
   --    config = function()
   --       require("chatgpt").setup({
   --          keymaps = {
   --             submit = "<C-CR>",
   --          },
   --       })
   --    end,
   --    -- <C-Enter> to submit.
   --    -- <C-c> to close chat window.
   --    -- <C-u> scroll up chat window.
   --    -- <C-d> scroll down chat window.
   --    -- <C-y> to copy/yank last answer.
   --    -- <C-k> to copy/yank code from last answer.
   --    -- <C-o> Toggle settings window.
   --    -- <C-n> Start new session.
   --    -- <Tab> Cycle over windows.
   --    -- <C-i> [Edit Window] use response as input.
   -- },
}
