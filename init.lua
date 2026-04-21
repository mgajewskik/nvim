local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup("plugins", {
   defaults = {
      lazy = false,
   },
   install = {
      missing = true,
   },
   change_detection = {
      enabled = false,
   },
})

require("filetypes")

vim.api.nvim_create_autocmd("User", {
   pattern = "VeryLazy",
   callback = function()
      require("keymaps")
      require("autocmd")
      -- require("filetypes")
      -- not needed anymore as I am using Obsidian.nvim
      -- require("fzk").setup()
   end,
})
