local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
nls.setup({
    sources = {
        nls.builtins.code_actions.shellcheck,
        -- diagnostics
        nls.builtins.diagnostics.actionlint,
        nls.builtins.diagnostics.cfn_lint,
        nls.builtins.diagnostics.yamllint,
        nls.builtins.diagnostics.flake8.with({
            extra_args = {
                "--max-line-length=120",
            },
        }),
        -- turning off as throwing too many errors
        -- nls.builtins.diagnostics.mypy,
        -- nls.builtins.diagnostics.pylint,
        nls.builtins.diagnostics.pyproject_flake8,
        -- nls.builtins.diagnostics.checkmake,
        nls.builtins.diagnostics.codespell,
        -- nls.builtins.diagnostics.eslint_d,
        nls.builtins.diagnostics.xo,
        nls.builtins.diagnostics.gitlint,
        nls.builtins.diagnostics.golangci_lint,
        nls.builtins.diagnostics.hadolint,
        nls.builtins.diagnostics.luacheck.with({
            extra_args = {
                "--globals",
                "vim",
                -- "--config",
                -- "~/.config/nvim/.luacheckrc",
            },
        }),
        -- gives weird underlines if no package comment - managed by a config file
        nls.builtins.diagnostics.revive,
        nls.builtins.diagnostics.staticcheck,
        nls.builtins.diagnostics.trail_space,
        -- formatters
        nls.builtins.formatting.fixjson,
        nls.builtins.formatting.jq,
        nls.builtins.formatting.yamlfmt,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.shellharden,
        -- this formatting is so slow
        -- nls.builtins.formatting.terraform_fmt,
        nls.builtins.formatting.black,
        nls.builtins.formatting.isort,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.gofumpt,
        -- changes some strings that need to be like they are
        -- nls.builtins.formatting.codespell,
        nls.builtins.formatting.eslint_d,
    },
    on_attach = function(client, bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if client.supports_method("textDocument/formatting") then
            -- TODO refactor this
            if (filetype ~= "json" and
                filetype ~= "yaml" and
                filetype ~= "sh") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end
        end
        require("utils").custom_lsp_attach(client, bufnr)
    end,
})