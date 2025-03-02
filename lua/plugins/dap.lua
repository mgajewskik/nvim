return {
   {
      "mfussenegger/nvim-dap",
      dependencies = {
         "leoluz/nvim-dap-go",
         "rcarriga/nvim-dap-ui",
         "theHamsta/nvim-dap-virtual-text",
         "nvim-neotest/nvim-nio",
         "williamboman/mason.nvim",
      },
      config = function()
         local dap = require("dap")
         local ui = require("dapui")

         require("dapui").setup()
         require("dap-go").setup()
         require("nvim-dap-virtual-text").setup()

         -- vim.fn.sign_define(
         --    "DapBreakpoint",
         --    { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
         -- )

         vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
         vim.keymap.set("n", "<space>dh", dap.run_to_cursor)

         -- Eval var under cursor
         vim.keymap.set("n", "<space>dv", function()
            require("dapui").eval(nil, { enter = true })
         end)

         vim.keymap.set("n", "<leader>dc", dap.continue)
         vim.keymap.set("n", "<leader>dj", dap.step_into)
         vim.keymap.set("n", "<leader>dl", dap.step_over)
         vim.keymap.set("n", "<leader>dk", dap.step_out)
         -- not supported in Go
         -- vim.keymap.set("n", "<F5>", dap.step_back)
         vim.keymap.set("n", "<leader>dr", dap.restart)

         dap.listeners.before.attach.dapui_config = function()
            ui.open()
         end
         dap.listeners.before.launch.dapui_config = function()
            ui.open()
         end
         dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
         end
         dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
         end
      end,
   },
   -- {
   --    -- https://github.com/igorlfs/nvim-dap-view
   --    "mfussenegger/nvim-dap",
   --    dependencies = {
   --       "leoluz/nvim-dap-go",
   --       { "igorlfs/nvim-dap-view", opts = {} },
   --    },
   --    config = function()
   --       local dap = require("dap")
   --       local ui = require("dap-view")
   --
   --       require("dap-go").setup()
   --
   --       -- vim.fn.sign_define(
   --       --    "DapBreakpoint",
   --       --    { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
   --       -- )
   --
   --       vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
   --       vim.keymap.set("n", "<space>dh", dap.run_to_cursor)
   --
   --       -- Eval var under cursor
   --       vim.keymap.set("n", "<space>dv", function()
   --          require("dapui").eval(nil, { enter = true })
   --       end)
   --
   --       vim.keymap.set("n", "<leader>dc", dap.continue)
   --       vim.keymap.set("n", "<leader>dj", dap.step_into)
   --       vim.keymap.set("n", "<leader>dl", dap.step_over)
   --       vim.keymap.set("n", "<leader>dk", dap.step_out)
   --       -- not supported in Go
   --       -- vim.keymap.set("n", "<F5>", dap.step_back)
   --       vim.keymap.set("n", "<leader>dr", dap.restart)
   --
   --       dap.listeners.before.attach.dapui_config = function()
   --          ui.open()
   --       end
   --       dap.listeners.before.launch.dapui_config = function()
   --          ui.open()
   --       end
   --       dap.listeners.before.event_terminated.dapui_config = function()
   --          ui.close()
   --       end
   --       dap.listeners.before.event_exited.dapui_config = function()
   --          ui.close()
   --       end
   --    end,
   -- },
}
