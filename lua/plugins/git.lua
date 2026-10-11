return {
   {
      "tpope/vim-fugitive",
      keys = {
         { "<leader>sg", "<cmd>Git<CR>" },
         { "<leader>gb", "<cmd>Git blame<CR>" },
         { "<leader>gc", "<cmd>Git commit<CR>" },
         { "<leader>gv", "<cmd>Gvdiffsplit!<CR>" },
         { "<leader>gl", "<cmd>Git log --graph --abbrev-commit --decorate<CR>" },
         { "<leader>sr", "<cmd>Git rebase -i HEAD~20<CR>" },
         { "<leader>gh", "<cmd>diffget //3<CR>" },
         { "<leader>gf", "<cmd>diffget //2<CR>" },
      },
   },
   {
      "lewis6991/gitsigns.nvim",
      opts = {},
   },
   {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      keys = {
         { "<leader>gdh", "<cmd>DiffviewFileHistory %<CR>" },
         { "<leader>gdd", ":DiffviewOpen origin/master" },
         { "<leader>gds", ":DiffviewOpen --staged" },
      },
      opts = {},
   },
   {
      "NeogitOrg/neogit",
      dependencies = { "sindrets/diffview.nvim", "ibhagwan/fzf-lua" },
      cmd = "Neogit",
      keys = {
         { "<leader>gs", "<cmd>Neogit<CR>" },
         { "<leader>gg", "<cmd>Neogit<CR>" },
      },
      opts = {},
   },
}
