return {
   {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      version = false,
      lazy = false,
      build = function()
         local ok, ts = pcall(require, "nvim-treesitter")
         if ok and ts.update then
            ts.update()
         end
      end,
      opts = {
         highlight = { enable = true },
         indent = { enable = true },
         folds = { enable = false },
         ensure_installed = {
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
         },
      },
      config = function(_, opts)
         local ts = require("nvim-treesitter")

         if not ts.get_installed then
            vim.notify("nvim-treesitter: run :TSUpdate and restart", vim.log.levels.ERROR)
            return
         end

         ts.setup(opts)

         local installed = ts.get_installed()
         local to_install = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
         end, opts.ensure_installed or {})

         if #to_install > 0 then
            ts.install(to_install)
         end

         vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
            callback = function(ev)
               local buf = ev.buf
               local ft = ev.match
               local lang = vim.treesitter.language.get_lang(ft) or ft

               local has_parser = pcall(vim.treesitter.language.inspect, lang)
               if not has_parser then
                  return
               end

               if opts.highlight and opts.highlight.enable then
                  pcall(vim.treesitter.start, buf)
               end

               if opts.indent and opts.indent.enable then
                  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
               end

               if opts.folds and opts.folds.enable then
                  vim.wo[0][0].foldmethod = "expr"
                  vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
               end
            end,
         })

         vim.treesitter.language.register("markdown", "octo")
      end,
   },
   {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      event = "VeryLazy",
      opts = {
         select = { lookahead = true },
         move = { set_jumps = true },
      },
      config = function(_, opts)
         local ts_textobjects = require("nvim-treesitter-textobjects")
         if not ts_textobjects.setup then
            vim.notify("nvim-treesitter-textobjects: update required", vim.log.levels.ERROR)
            return
         end
         ts_textobjects.setup(opts)

         vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_textobjects", { clear = true }),
            callback = function(ev)
               local buf = ev.buf
               local ft = ev.match
               local lang = vim.treesitter.language.get_lang(ft) or ft
               local has_parser = pcall(vim.treesitter.language.inspect, lang)
               if not has_parser then
                  return
               end

               local select_mod = require("nvim-treesitter-textobjects.select")
               local move_mod = require("nvim-treesitter-textobjects.move")

               local select_maps = {
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["ac"] = "@class.outer",
                  ["ic"] = "@class.inner",
                  ["al"] = "@loop.outer",
                  ["il"] = "@loop.inner",
                  ["ab"] = "@block.outer",
                  ["ib"] = "@block.inner",
                  ["ar"] = "@parameter.outer",
                  ["ir"] = "@parameter.inner",
               }
               for key, query in pairs(select_maps) do
                  vim.keymap.set({ "x", "o" }, key, function()
                     select_mod.select_textobject(query, "textobjects")
                  end, { buffer = buf, silent = true })
               end

               local move_maps = {
                  ["]]"] = { "goto_next_start", "@function.outer" },
                  ["[["] = { "goto_previous_start", "@function.outer" },
                  ["]m"] = { "goto_next_start", "@class.outer" },
                  ["[m"] = { "goto_previous_start", "@class.outer" },
               }
               for key, cfg in pairs(move_maps) do
                  vim.keymap.set({ "n", "x", "o" }, key, function()
                     move_mod[cfg[1]](cfg[2], "textobjects")
                  end, { buffer = buf, silent = true })
               end
            end,
         })
      end,
   },
   -- NOTE: turning off for now as not working properly, indentation always starts from the new line
   -- {
   --    "wurli/contextindent.nvim",
   --    -- This is the only config option; you can use it to restrict the files
   --    -- which this plugin will affect (see :help autocommand-pattern).
   --    opts = { pattern = "*" },
   --    dependencies = { "nvim-treesitter/nvim-treesitter" },
   -- },
}
