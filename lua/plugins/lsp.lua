return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "mason.nvim",
         { "mason-org/mason-lspconfig.nvim", config = function() end },
         "saghen/blink.cmp",
      },
      event = { "BufReadPre", "BufNewFile" },
      opts = {
         diagnostics = {
            underline = true,
            update_in_insert = true,
            virtual_text = { spacing = 4, prefix = "●", source = "always" },
            severity_sort = true,
         },
         servers = {
            -- has formatting
            jsonls = {},
            yamlls = {
               settings = {
                  yaml = {
                     -- FIX mapKeyOrder warning
                     keyOrdering = false,
                  },
               },
            },
            bashls = {},
            dockerls = {},
            gopls = {
               -- filetypes = { "go", "gomod", "gohtmltmpl", "gotexttmpl" },
               settings = {
                  gopls = {
                     -- remote = "auto",
                     gofumpt = true,
                     analyses = {
                        shadow = true,
                        unusedparams = true,
                        unusedvariable = true,
                     },
                     staticcheck = true,
                     formatting = {
                        gofumpt = true,
                     },
                  },
               },
            },
            stylua = { enabled = false },
            lua_ls = {
               -- TODO add indent width 3 spaces
               settings = {
                  Lua = {
                     diagnostics = {
                        globals = { "vim", "require" },
                     },
                     completion = {
                        callSnippet = "Replace",
                     },
                  },
               },
            },
            pyright = {},
            ruff = {
               -- https://pypi.org/project/ruff/0.0.47/
               init_options = {
                  settings = {
                     args = {
                        "--config",
                        "$HOME/.config/ruff.toml",
                     },
                  },
               },
            },
            tflint = {},
            marksman = {},
            vimls = {},
            spectral = {},
            buf_ls = {},
            -- TODO add taplo to this setup
            hyprls = {
               filetypes = { "*.hl", "hypr*.conf" },
            },
            ts_ls = {},
         },
         setup = {},
      },
      config = function(_, opts)
         require("utils").lsp_on_attach()

         -- diagnostics
         if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
            opts.diagnostics.virtual_text.prefix = function(diagnostic)
               local icons = require("icons").icons.diagnostics
               for d, icon in pairs(icons) do
                  if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                     return icon
                  end
               end
               return "●"
            end
         end
         vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

         local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
         capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
         }

         if opts.servers["*"] then
            vim.lsp.config("*", opts.servers["*"])
         end

         local mason_all = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package) or {}
         local mason_exclude = {} ---@type string[]

         local function configure(server)
            if server == "*" then
               return false
            end
            local sopts = opts.servers[server]
            sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

            if sopts.enabled == false then
               mason_exclude[#mason_exclude + 1] = server
               return
            end

            local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
            local setup = opts.setup[server] or opts.setup["*"]
            if setup and setup(server, sopts) then
               mason_exclude[#mason_exclude + 1] = server
            else
               vim.lsp.config(server, sopts) -- configure the server
               if not use_mason then
                  vim.lsp.enable(server)
               end
            end
            return use_mason
         end

         local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
         require("mason-lspconfig").setup({
            ensure_installed = install,
            automatic_enable = { exclude = mason_exclude },
         })
      end,
   },
   {
      "simrat39/symbols-outline.nvim",
      lazy = true,
      cmd = "SymbolsOutline",
      config = true,
   },
   {
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      opts = { use_diagnostic_signs = true },
   },
   {
      "folke/lazydev.nvim",
      ft = "lua",
      cmd = "LazyDev",
      opts = {},
   },
   {
      -- https://cmp.saghen.dev/
      "saghen/blink.cmp",
      dependencies = {
         -- "rafamadriz/friendly-snippets",
         "mikavilpas/blink-ripgrep.nvim",
         "folke/lazydev.nvim",
         "moyiz/blink-emoji.nvim",
      },
      version = "*",
      opts = {
         completion = {
            accept = { auto_brackets = { enabled = true }, dot_repeat = false },
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = {
               auto_show = true,
               auto_show_delay_ms = 250,
               treesitter_highlighting = true,
               window = {
                  max_width = 120,
                  max_height = 60,
               },
            },
            menu = {
               draw = {
                  treesitter = { "lsp" },
               },
            },
            ghost_text = { enabled = false },
         },
         signature = {
            enabled = true,
         },
         appearance = {
            nerd_font_variant = "mono",
         },
         keymap = {
            preset = "enter",
            ["<CR>"] = { "accept", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
         },
         cmdline = {
            completion = {
               menu = {
                  auto_show = true,
               },
            },
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
         sources = {
            default = function()
               local cwd = vim.fn.getcwd()
               if cwd == vim.fn.expand("$HOME") or cwd == vim.fn.expand("$HOME/.config") then
                  -- return { "lazydev", "lsp", "path", "buffer", "codecompanion", "emoji" }
                  return { "lazydev", "lsp", "path", "buffer", "codecompanion" }
                  -- return { "lazydev", "lsp", "path", "buffer" }
               else
                  -- return { "lazydev", "lsp", "path", "buffer", "codecompanion", "emoji", "ripgrep" }
                  -- return { "lazydev", "lsp", "path", "buffer", "codecompanion", "ripgrep" }
                  return { "lazydev", "lsp", "path", "buffer", "ripgrep" }
               end
            end,
            providers = {
               codecompanion = {
                  name = "CodeCompanion",
                  module = "codecompanion.providers.completion.blink",
               },
               ripgrep = {
                  module = "blink-ripgrep",
                  name = "Ripgrep",
                  opts = {
                     prefix_min_len = 5,
                     -- context_size = 5,
                     -- max_filesize = "1M",
                     project_root_marker = { ".git", "go.mod" },
                     -- search_casing = "--smart-case",
                     -- additional_rg_options = { "--ignore-file $HOME/.gitignore_global" },
                     fallback_to_regex_highlighting = true,
                  },
               },
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  -- make lazydev completions top priority (see `:h blink.cmp`)
                  score_offset = 100,
               },
               emoji = {
                  module = "blink-emoji",
                  name = "Emoji",
                  score_offset = 15, -- Tune by preference
                  opts = { insert = true }, -- Insert emoji (default) or complete its name
               },
            },
         },
         backend = {
            context_size = 5,
            ripgrep = {
               additional_rg_options = { "--ignore-file $HOME/.gitignore_global" },
               max_filesize = "1M",
               search_casing = "--smart-case",
            },
         },
      },
   },
}
