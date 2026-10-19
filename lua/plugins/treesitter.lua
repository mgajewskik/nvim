return {
   {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
         -- install() skips parsers that are already installed
         local install = require("nvim-treesitter").install({
            "bash",
            "css",
            "cmake",
            "make",
            "dockerfile",
            "go",
            "gomod",
            "gowork",
            "gosum",
            "gotmpl",
            "proto",
            "hcl",
            "terraform",
            "html",
            "javascript",
            "typescript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "toml",
            "yaml",
            "rego",
            "comment",
            "diff",
            "gitcommit",
            "gitignore",
            "regex",
            "sql",
            "vim",
            "vimdoc",
            "nix",
            "hyprlang",
         })
         -- headless (my dotfiles install the plugins this way): wait, so the parsers exist when nvim quits
         if #vim.api.nvim_list_uis() == 0 then
            install:wait(300000)
         end

         vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
            callback = function(ev)
               if pcall(vim.treesitter.start, ev.buf) then
                  vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
               end
            end,
         })
      end,
   },
}
