return {
   {
      "ray-x/go.nvim",
      dependencies = {
         "ray-x/guihua.lua",
         "neovim/nvim-lspconfig",
         "nvim-treesitter/nvim-treesitter",
      },
      lazy = true,
      -- event = { "CmdlineEnter" },
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
      opts = {
         remap_commands = {
            GoDoc = false,
         },
         -- goimports = "golines",
         lsp_cfg = true,
         lsp_gofumpt = true,
         -- lsp_on_attach = nil,
         -- lsp_on_attach = function(client, bufnr)
         --    require("utils").on_attach(client, bufnr)
         -- end,
         -- lsp_on_attach = function(client, buffer)
         --    require("utils").on_attach(function(client, buffer)
         --       -- require("utils").format_on_attach(client, buffer)
         --       require("utils").keymaps_on_attach(client, buffer)
         --    end)
         -- end,
         lsp_on_attach = function(client, bufnr)
            require("utils").lsp_on_attach()
         end,
         lsp_codelens = false,
         lsp_keymaps = false,
         lsp_diag_update_in_insert = true,
         lsp_document_formatting = false,
         dap_debug_keymap = false,
         icons = { breakpoint = "B", currentpos = "C" }, -- setup to `false` to disable icons setup
         build_tags = "",
         run_in_floaterm = true,
         -- luasnip = true,
         lsp_inlay_hints = {
            enable = false, -- cannot be false as it throuws an error at LSP setup
            -- -- Only show inlay hints for the current line
            -- only_current_line = true,
            -- -- Event which triggers a refersh of the inlay hints.
            -- -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- -- not that this may cause higher CPU usage.
            -- -- This option is only respected when only_current_line and
            -- -- autoSetHints both are true.
            -- only_current_line_autocmd = "CursorHold",
            -- -- whether to show variable name before type hints with the inlay hints or not
            -- -- default: false
            -- show_variable_name = true,
            -- -- prefix for parameter hints
            -- parameter_hints_prefix = "󰊕 ",
            -- show_parameter_hints = true,
            -- -- prefix for all the other hints (type, chaining)
            -- other_hints_prefix = "=> ",
            -- -- whether to align to the lenght of the longest line in the file
            -- max_len_align = false,
            -- -- padding from the left if max_len_align is true
            -- max_len_align_padding = 1,
            -- -- whether to align to the extreme right or not
            -- right_align = false,
            -- -- padding from the right if right_align is true
            -- right_align_padding = 6,
            -- -- The color of the hints
            -- highlight = "Comment",
         },
      },
   },
   {
      "fredrikaverpil/godoc.nvim",
      version = "*",
      dependencies = {
         {
            "nvim-treesitter/nvim-treesitter",
            opts = {
               ensure_installed = { "go" },
            },
         },
      },
      -- build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
      cmd = { "GoDoc" },
      opts = {
         window = {
            type = "vsplit",
         },
         picker = {
            type = "telescope",
         },
      },
   },
   {
      "hashivim/vim-terraform",
      config = function()
         vim.cmd("let g:terraform_align=1")
         vim.cmd("let g:terraform_fold_sections=0")
         vim.cmd("let g:terraform_fmt_on_save=1")
         vim.cmd("let g:hcl_align=1")
      end,
   },
   {
      "stevearc/conform.nvim",
      opts = {
         formatters_by_ft = {
            lua = { "stylua" },
            -- python = { "isort", "black", "ruff" },
            -- python = { "isort", "ruff_fix", "ruff_format", "ruff_organize_imports" },
            -- ruff_format messes with the formatting, works via gf in LSP
            -- python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
            python = { "ruff_fix", "ruff_organize_imports" },
            -- python = { "isort", "ruff_organize_imports" },
            -- go = { "golines", "gofumpt", "goimports" },
            -- go = { "gofumpt", "goimports" },
            go = { "goimports" },
            -- go = { "golines", "gofumpt", "goimports-reviser" },  -- reviser needs additional setup to change the order of imported groups
            json = { "jq" },
            yaml = { "yamlfmt" },
            -- sh = { "shfmt", "shellcheck", "shellharden" },
            sh = { "shfmt" },
            -- toml = { "taplo" },
            sql = { "pg_format" },
            gohtmltmpl = { "djlint" },
            -- terraform = { "terraform_fmt" },  -- moves cursor to the end of the file
            hcl = { "terraform_fmt" },
            nix = { "nixfmt" },
         },
         notify_on_error = true,
         format_on_save = function(bufnr)
            if vim.bo[bufnr].filetype == "yaml" then
               vim.b[bufnr].disable_autoformat = true
            end
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
               return
            end
            return { timeout_ms = 1000, lsp_format = "never" }
         end,
      },
      config = function(_, opts)
         local util = require("conform.util")
         require("conform").setup(opts)

         -- require("conform.formatters.jq").args = { "--indent", "4" }
         local jq = require("conform.formatters.jq")
         require("conform").formatters.jq = vim.tbl_deep_extend("force", jq, {
            args = util.extend_args(jq.args, { "--indent", "2" }),
         })

         local stylua = require("conform.formatters.stylua")
         require("conform").formatters.stylua = vim.tbl_deep_extend("force", stylua, {
            args = util.extend_args(stylua.args, { "--indent-width", "3", "--indent-type", "Spaces" }),
         })

         local cmd = vim.api.nvim_create_user_command
         cmd("FormatDisable", function(args)
            if args.bang then
               -- FormatDisable! will disable formatting just for this buffer
               vim.b.disable_autoformat = true
            else
               vim.g.disable_autoformat = true
            end
         end, {
            desc = "Disable autoformat-on-save",
            bang = true,
         })

         cmd("FormatEnable", function(args)
            if args.bang then
               -- FormatEnable! will enable formatting just for this buffer
               vim.b.disable_autoformat = false
            else
               vim.g.disable_autoformat = false
            end
         end, {
            desc = "Re-enable autoformat-on-save",
         })
      end,
   },
   {
      "mfussenegger/nvim-lint",
      opts = {
         linters_by_ft = {
            -- yaml = { "actionlint", "cfn_lint", "yamllint" },
            -- yaml = { "actionlint", "yamllint" },
            yaml = { "yamllint" },
            -- go = { "golangcilint" }, -- golangci-lint is not working
            -- go = { "golangcilint", "revive" }, -- golangci-lint is not working
            go = { "revive" },
            proto = { "protolint" },
            lua = { "luacheck" },
            terraform = { "tfsec" },
            dockerfile = { "hadolint" },
            json = { "jsonlint" },
            sql = { "sqlfluff" },
            nix = { "nix" },
         },
      },
      config = function(_, opts)
         require("lint").linters_by_ft = opts.linters_by_ft

         require("lint.linters.luacheck").args =
            { "--formatter", "plain", "--codes", "--ranges", "-", "--globals", "vim" }

         vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            callback = function()
               require("lint").try_lint()
            end,
         })
      end,
   },
   {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = {
         -- https://mason-registry.dev/registry/list
         ensure_installed = {
            -- linters
            "actionlint",
            "cfn-lint",
            "yamllint",
            "golangci-lint",
            "revive",
            "luacheck",
            "tfsec",
            "hadolint",
            "jsonlint",
            "sqlfluff",
            "protolint",
            -- formatters
            "stylua",
            "isort",
            "black",
            "ruff",
            "golines",
            "gofumpt",
            "goimports",
            "goimports-reviser",
            "jq",
            "yamlfmt",
            "shfmt",
            "shellcheck",
            "shellharden",
            "taplo",
            "djlint",
            "hyprls",
         },
      },
      config = function(_, opts)
         require("mason").setup(opts)
         local mr = require("mason-registry")
         local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
               local p = mr.get_package(tool)
               if not p:is_installed() then
                  p:install()
               end
            end
         end
         if mr.refresh then
            mr.refresh(ensure_installed)
         else
            ensure_installed()
         end
      end,
   },
}
