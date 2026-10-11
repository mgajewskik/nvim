return {
   {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      config = function()
         require("kanagawa").setup({
            overrides = function()
               return {
                  Search = { fg = "#0F1F28", bg = "#FF9E3B" },
                  Visual = { bg = "#54546D" },
                  SignColumn = { bg = "#1F1F28" },
                  LineNr = { bg = "#1F1F28" },
               }
            end,
         })
         vim.cmd.colorscheme("kanagawa")
      end,
   },
   {
      "nvim-lualine/lualine.nvim",
      dependencies = { "kyazdani42/nvim-web-devicons" },
      opts = {
         options = {
            theme = "kanagawa",
            always_divide_middle = false,
         },
         sections = {
            lualine_a = { "branch" },
            lualine_b = {},
            lualine_c = {
               {
                  "diagnostics",
                  symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f835} " },
               },
               { "filetype", icon_only = true },
               {
                  "filename",
                  path = 1, -- relative path
                  symbols = { modified = "\u{f0fe} ", readonly = " \u{f840}" },
               },
            },
            lualine_x = { "encoding", "fileformat", "filesize" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
         },
         extensions = { "nvim-tree", "toggleterm", "quickfix" },
      },
   },
   {
      "echasnovski/mini.indentscope",
      opts = {
         draw = {
            delay = 10,
            animation = function()
               return 5
            end,
         },
         options = { try_as_border = true },
      },
   },
   {
      "uga-rosa/ccc.nvim",
      opts = {
         highlighter = { auto_enable = true },
      },
   },
   {
      "akinsho/toggleterm.nvim",
      keys = {
         { "<C-\\>", "<cmd>ToggleTerm<CR>" },
      },
      opts = {
         open_mapping = [[<C-\>]],
         shading_factor = "1",
         direction = "float",
         float_opts = {
            border = "rounded",
            winblend = 5,
         },
      },
   },
}
