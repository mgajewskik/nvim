return {
   {
      "lambdalisue/suda.vim",
      cmd = { "SudaRead", "SudaWrite" },
   },
   {
      "tpope/vim-surround",
      event = "VeryLazy",
   },
   {
      -- easy align with gl=
      "tommcdo/vim-lion",
   },
   {
      -- keeps undo history when a file changes outside nvim
      "kevinhwang91/nvim-fundo",
      dependencies = { "kevinhwang91/promise-async" },
      opts = {},
   },
   {
      "echasnovski/mini.pairs",
      event = "VeryLazy",
      opts = {
         mappings = {
            ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%a\\].", register = { cr = false } },
            ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
            ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%a\\].", register = { cr = false } },
         },
      },
   },
   {
      "tpope/vim-obsession",
   },
}
