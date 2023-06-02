return {
   {
      "mfussenegger/nvim-dap",
      lazy = true,
   },
   {
      "theHamsta/nvim-dap-virtual-text",
      dependencies = {
         "mfussenegger/nvim-dap",
      },
      lazy = true,
      opts = {
         commented = true,
      },
   },
   {
      "rcarriga/nvim-dap-ui",
      dependencies = {
         "mfussenegger/nvim-dap",
      },
      lazy = true,
   },
   {
      "mfussenegger/nvim-dap-python",
      dependencies = {
         "mfussenegger/nvim-dap",
      },
      lazy = true,
   },
   {
      "leoluz/nvim-dap-go",
      dependencies = {
         "mfussenegger/nvim-dap",
      },
      lazy = true,
   },
}