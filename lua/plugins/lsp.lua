-- nvim-lspconfig server name -> mason package
local servers = {
   bashls = "bash-language-server",
   buf_ls = "buf",
   dockerls = "dockerfile-language-server",
   gopls = "gopls",
   jsonls = "json-lsp",
   lua_ls = "lua-language-server",
   ruff = "ruff",
   rust_analyzer = "rust-analyzer",
   terraformls = "terraform-ls",
   tflint = "tflint",
   ts_ls = "typescript-language-server",
   ty = "ty",
   yamlls = "yaml-language-server",
}
-- Other mason packages: shfmt is what bashls formats with
local tools = { "shfmt" }

return {
   {
      "mason-org/mason.nvim",
      cmd = "Mason",
      build = ":MasonUpdate",
      config = function()
         require("mason").setup()

         -- Checks the install dir only; the registry is loaded just when something is missing
         local registry = require("mason-registry")
         local missing = vim.tbl_filter(function(pkg)
            return not registry.is_installed(pkg)
         end, vim.list_extend(vim.tbl_values(servers), tools))
         if #missing > 0 then
            registry.refresh(function()
               for _, pkg in ipairs(missing) do
                  registry.get_package(pkg):install()
               end
            end)
         end
      end,
   },
   {
      "neovim/nvim-lspconfig",
      dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
      event = { "BufReadPre", "BufNewFile" },
      config = function()
         vim.diagnostic.config({
            update_in_insert = true,
            severity_sort = true,
            virtual_text = { spacing = 4, prefix = "●", source = true },
            float = { border = "rounded" },
            jump = {
               on_jump = function(diagnostic, bufnr)
                  if diagnostic then
                     vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
                  end
               end,
            },
         })

         vim.lsp.config("gopls", {
            -- one shared gopls daemon for all nvim instances
            cmd = { "gopls", "-remote=auto" },
            settings = {
               gopls = {
                  gofumpt = true,
                  analyses = {
                     shadow = true,
                     unusedparams = true,
                     unusedvariable = true,
                  },
                  staticcheck = true,
               },
            },
         })
         vim.lsp.config("yamlls", {
            -- FIX mapKeyOrder warning
            settings = { yaml = { keyOrdering = false } },
         })
         vim.lsp.config("lua_ls", {
            settings = {
               Lua = {
                  diagnostics = { globals = { "vim", "require" } },
                  completion = { callSnippet = "Replace" },
               },
            },
         })
         vim.lsp.enable(vim.tbl_keys(servers))

         -- Built-in maps cover the rest: grn, gra, grr, gri, grt, gO, K, [d, ]d
         vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
               local opts = { buffer = args.buf, silent = true }
               vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
               vim.keymap.set("n", "gD", function()
                  vim.cmd.vsplit()
                  vim.lsp.buf.definition()
               end, opts)
               vim.keymap.set("n", "gf", vim.lsp.buf.format, opts)
               -- keep gq on the built-in formatter
               vim.bo[args.buf].formatexpr = ""
            end,
         })
      end,
   },
   {
      -- https://cmp.saghen.dev/
      "saghen/blink.cmp",
      dependencies = { "mikavilpas/blink-ripgrep.nvim" },
      version = "v1",
      opts = {
         completion = {
            accept = { dot_repeat = false },
            list = { selection = { preselect = false } },
            documentation = {
               auto_show = true,
               auto_show_delay_ms = 250,
               window = { max_width = 120, max_height = 60 },
            },
            menu = { draw = { treesitter = { "lsp" } } },
         },
         signature = { enabled = true },
         sources = {
            default = function()
               -- no ripgrep source when nvim is opened in $HOME or ~/.config
               local cwd = vim.fn.getcwd()
               if cwd == vim.fn.expand("$HOME") or cwd == vim.fn.expand("$HOME/.config") then
                  return { "lsp", "path", "buffer" }
               end
               return { "lsp", "path", "buffer", "ripgrep" }
            end,
            providers = {
               -- https://github.com/mikavilpas/blink-ripgrep.nvim?tab=readme-ov-file#full-config
               ripgrep = {
                  module = "blink-ripgrep",
                  name = "Ripgrep",
                  opts = {
                     prefix_min_len = 5,
                     project_root_marker = { ".git", "go.mod" },
                     fallback_to_regex_highlighting = true,
                     backend = {
                        ripgrep = {
                           context_size = 5,
                           -- rg runs without a shell: flag and path are separate args, path expanded here
                           additional_rg_options = { "--ignore-file", vim.fn.expand("~/.config/git/ignore") },
                           max_filesize = "1M",
                           search_casing = "--smart-case",
                        },
                     },
                  },
               },
            },
         },
         keymap = {
            preset = "enter",
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
         },
         cmdline = {
            completion = { menu = { auto_show = true } },
            keymap = {
               preset = "none",
               ["<CR>"] = { "fallback" },
               ["<C-j>"] = { "select_next", "fallback" },
               ["<C-k>"] = { "select_prev", "fallback" },
            },
            sources = function()
               local type = vim.fn.getcmdtype()
               if type == "/" or type == "?" then
                  return { "buffer" }
               end
               if type == ":" then
                  return { "cmdline" }
               end
               return {}
            end,
         },
      },
   },
}
