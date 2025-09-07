return {
   {
      -- https://codecompanion.olimorris.dev/
      "olimorris/codecompanion.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
         -- "ravitemer/mcphub.nvim",
         { "MeanderingProgrammer/render-markdown.nvim", ft = { "codecompanion" } },
      },
      keys = {
         { "<C-f>", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true } },
         -- { "ga", "<cmd>CodeCompanionChat Add<cr>", { mode = "v", noremap = true, silent = true } },
      },
      -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      -- https://github.com/oca159/lazyvim/blob/main/lua/plugins/codecompanion.lua
      opts = {
         adapters = {
            anthropic = function()
               return require("codecompanion.adapters").extend("anthropic", {
                  schema = {
                     -- model = {
                     --    default = "claude-3-7-sonnet-20250219",
                     -- },
                     extended_thinking = {
                        default = false,
                     },
                  },
               })
            end,
            gemini = function()
               return require("codecompanion.adapters").extend("gemini", {
                  schema = {
                     model = {
                        default = "gemini-2.5-pro",
                     },
                  },
               })
            end,
         },
         display = {
            chat = {
               window = {
                  -- this is only because it is covering other files when turned on and changin layout of them
                  layout = "float",
               },
               render_headers = false, -- Use RenderMarkdown instead
            },
            action_palette = {
               provider = "fzf_lua",
            },
         },
         -- fzf_lua will work after this is merged: https://github.com/olimorris/codecompanion.nvim/pull/872
         strategies = {
            chat = {
               -- adapter = "anthropic",
               adapter = "gemini",
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
               -- tools = {
               --    ["mcp"] = {
               --       -- calling it in a function would prevent mcphub from being loaded before it's needed
               --       callback = function()
               --          return require("mcphub.extensions.codecompanion")
               --       end,
               --       description = "Call tools and resources from the MCP Servers",
               --       opts = {
               --          requires_approval = true,
               --       },
               --    },
               -- },
            },
            inline = {
               -- adapter = "anthropic",
               adapter = "gemini",
            },
            cmd = {
               -- adapter = "anthropic",
               adapter = "gemini",
            },
         },
      },
   },
   {
      "NickvanDyke/opencode.nvim",
      dependencies = {
         "folke/snacks.nvim",
      },
      keys = {
         {
            "<leader>ot",
            function()
               require("opencode").toggle()
            end,
            desc = "Toggle embedded opencode",
         },
         {
            "<leader>oa",
            function()
               require("opencode").ask()
            end,
            desc = "Ask opencode",
            mode = "n",
         },
         {
            "<leader>oa",
            function()
               require("opencode").ask("@selection: ")
            end,
            desc = "Ask opencode about selection",
            mode = "v",
         },
         -- {
         --    "<leader>ot",
         --    function()
         --       require("snacks.terminal").toggle("opencode", { win = { position = "right" } })
         --    end,
         --    desc = "Toggle opencode",
         -- },
      },
   },
   -- {
   -- used on a per project basis
   --    "augmentcode/augment.vim",
   --    lazy = false,
   --    keys = {
   --       { "<leader>ac", ":Augment chat-toggle<CR>", { noremap = true, silent = true } },
   --    },
   --    config = function()
   --       if vim.fn.system("git rev-parse --is-inside-work-tree"):match("true") then
   --          vim.g.augment_workspace_folders = { vim.fn.getcwd() }
   --       end
   --
   --       -- local disabled_filetypes = {
   --       --    "markdown",
   --       --    "telekasten",
   --       -- }
   --
   --       -- -- NOTE: that works nicely but I wonder how useful that is as the files probaby still get send online
   --       -- local function should_disable_completions()
   --       --    return vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
   --       -- end
   --       --
   --       -- local augroup = vim.api.nvim_create_augroup("AugmentDisable", { clear = true })
   --       --
   --       -- vim.api.nvim_create_autocmd("BufEnter", {
   --       --    group = augroup,
   --       --    pattern = "*",
   --       --    callback = function()
   --       --       if should_disable_completions() then
   --       --          vim.g.augment_disable_completions = true
   --       --       end
   --       --    end,
   --       -- })
   --       --
   --       -- vim.api.nvim_create_autocmd("BufLeave", {
   --       --    group = augroup,
   --       --    pattern = "*",
   --       --    callback = function()
   --       --       if should_disable_completions() then
   --       --          vim.g.augment_disable_completions = false
   --       --       end
   --       --    end,
   --       -- })
   --    end,
   -- },
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
   -- {
   --    "supermaven-inc/supermaven-nvim",
   --    lazy = false,
   --    keys = {
   --       { "<leader>cc", ":SupermavenToggle<CR>", { noremap = true, silent = true } },
   --    },
   --    config = function()
   --       require("supermaven-nvim").setup({
   --          keymaps = {
   --             accept_suggestion = "<Tab>",
   --             accept_word = "<C-l>",
   --          },
   --          ignore_filetypes = { "markdown", "codecompanion" },
   --       })
   --    end,
   -- },
   -- {
   --    "ravitemer/mcphub.nvim",
   --    dependencies = {
   --       "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
   --    },
   --    -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
   --    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
   --    config = function()
   --       require("mcphub").setup({
   --          -- Required options
   --          port = 3000, -- Port for MCP Hub server
   --          config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
   --
   --          -- Optional options
   --          on_ready = function(hub)
   --             -- Called when hub is ready
   --          end,
   --          on_error = function(err)
   --             -- Called on errors
   --          end,
   --          log = {
   --             level = vim.log.levels.WARN,
   --             to_file = false,
   --             file_path = nil,
   --             prefix = "MCPHub",
   --          },
   --       })
   --    end,
   -- },
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
