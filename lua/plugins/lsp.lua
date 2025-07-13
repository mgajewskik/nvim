return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "mason.nvim",
         "williamboman/mason-lspconfig.nvim",
         -- "hrsh7th/cmp-nvim-lsp",
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
                     telemetry = {
                        enable = false,
                     },
                  },
               },
            },
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
         -- require("utils").on_attach(function(client, buffer)
         --    -- require("utils").format_on_attach(client, buffer)
         --    require("utils").keymaps_on_attach(client, buffer)
         -- end)
         require("utils").lsp_on_attach()

         -- diagnostics
         -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#customizing-how-diagnostics-are-displayed
         for name, icon in pairs(require("icons").icons.diagnostics) do
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
         end
         vim.diagnostic.config(opts.diagnostics)

         -- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
         local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
         capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
         }

         local servers = opts.servers

         local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
               capabilities = vim.deepcopy(capabilities),
            }, servers[server] or {})

            if opts.setup[server] then
               if opts.setup[server](server, server_opts) then
                  return
               end
            elseif opts.setup["*"] then
               if opts.setup["*"](server, server_opts) then
                  return
               end
            end
            require("lspconfig")[server].setup(server_opts)
         end

         -- get all the servers that are available thourgh mason-lspconfig
         local have_mason, mlsp = pcall(require, "mason-lspconfig")
         local all_mslp_servers = {}
         if have_mason then
            all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
         end

         local ensure_installed = {} ---@type string[]
         for server, server_opts in pairs(servers) do
            if server_opts then
               server_opts = server_opts == true and {} or server_opts
               -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
               if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                  setup(server)
               else
                  ensure_installed[#ensure_installed + 1] = server
               end
            end
         end

         if have_mason then
            mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
         end
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
                  return { "lazydev", "lsp", "path", "buffer", "codecompanion", "ripgrep" }
                  -- return { "lazydev", "lsp", "path", "buffer", "ripgrep" }
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
                     context_size = 5,
                     max_filesize = "1M",
                     project_root_marker = { ".git", "go.mod" },
                     search_casing = "--smart-case",
                     additional_rg_options = { "--ignore-file $HOME/.gitignore_global" },
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
      },
   },
   -- {
   --    "hrsh7th/nvim-cmp",
   --    dependencies = {
   --       "neovim/nvim-lspconfig",
   --       "onsails/lspkind-nvim",
   --       "hrsh7th/cmp-buffer",
   --       "hrsh7th/cmp-nvim-lsp",
   --       "hrsh7th/cmp-path",
   --       "hrsh7th/cmp-cmdline",
   --       "lukas-reineke/cmp-rg",
   --       "hrsh7th/cmp-nvim-lsp-signature-help",
   --       "hrsh7th/cmp-nvim-lsp-document-symbol",
   --       -- "L3MON4D3/LuaSnip",
   --       "hrsh7th/cmp-nvim-lua",
   --       "petertriho/cmp-git",
   --    },
   --    config = function()
   --       local cmp = require("cmp")
   --       local lspkind = require("lspkind")
   --
   --       ---@diagnostic disable-next-line: missing-fields
   --       cmp.setup({
   --          ---@diagnostic disable-next-line: missing-fields
   --          formatting = {
   --             format = lspkind.cmp_format({
   --                with_text = false,
   --                maxwidth = 120,
   --                mode = "symbol",
   --                menu = {
   --                   buffer = "BUF",
   --                   rg = "RG",
   --                   nvim_lsp = "LSP",
   --                   path = "PATH",
   --                   luasnip = "SNIP",
   --                   calc = "CALC",
   --                   spell = "SPELL",
   --                },
   --             }),
   --          },
   --          -- snippet = {
   --          --    expand = function(args)
   --          --       require("luasnip").lsp_expand(args.body)
   --          --    end,
   --          -- },
   --          mapping = {
   --             ["<C-d>"] = cmp.mapping.scroll_docs(4),
   --             ["<C-u>"] = cmp.mapping.scroll_docs(-4),
   --             ["<C-Space>"] = cmp.mapping.complete(),
   --             ["<C-e>"] = cmp.mapping.close(),
   --             ["<CR>"] = cmp.mapping.confirm({
   --                behavior = cmp.ConfirmBehavior.Replace,
   --                select = false,
   --             }),
   --             ["<C-j>"] = cmp.mapping(function(fallback)
   --                if cmp.visible() then
   --                   cmp.select_next_item()
   --                else
   --                   fallback()
   --                end
   --             end, { "i", "s" }),
   --             ["<C-k>"] = cmp.mapping(function()
   --                if cmp.visible() then
   --                   cmp.select_prev_item()
   --                end
   --             end, { "i", "s" }),
   --          },
   --          sources = {
   --             { name = "nvim_lua" },
   --             { name = "path" },
   --             { name = "nvim_lsp" },
   --             { name = "nvim_lsp_signature_help" },
   --             { name = "git" },
   --             { name = "buffer", keyword_length = 5 },
   --             { name = "luasnip" },
   --             { name = "rg", keyword_length = 5 },
   --          },
   --       })
   --
   --       -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
   --       ---@diagnostic disable-next-line: missing-fields
   --       cmp.setup.cmdline("/", {
   --          mapping = cmp.mapping.preset.cmdline(),
   --          sources = cmp.config.sources({
   --             { name = "nvim_lsp_document_symbol" },
   --          }, {
   --             { name = "buffer" },
   --          }),
   --       })
   --
   --       -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
   --       ---@diagnostic disable-next-line: missing-fields
   --       cmp.setup.cmdline(":", {
   --          mapping = cmp.mapping.preset.cmdline(),
   --          sources = cmp.config.sources({
   --             { name = "path" },
   --          }, {
   --             { name = "cmdline" },
   --          }),
   --       })
   --    end,
   -- },
}
