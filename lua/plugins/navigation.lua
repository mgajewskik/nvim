return {
   {
      url = "https://codeberg.org/andyg/leap.nvim",
      event = "VeryLazy",
      config = function()
         vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
         vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      end,
   },
   {
      "ggandor/flit.nvim",
      dependencies = {
         { url = "https://codeberg.org/andyg/leap.nvim" },
      },
      event = "VeryLazy",
      config = function()
         require("flit").setup()
      end,
   },
   {
      "mikavilpas/yazi.nvim",
      keys = {
         {
            "<C-e>",
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
         },
      },
      opts = {
         open_for_directories = true,
         keymaps = {
            show_help = "<f1>",
            change_working_directory = "<c-d>",
         },
         floating_window_scaling_factor = 0.7,
         integrations = {
            grep_in_selected_files = "fzf-lua",
            grep_in_directory = "fzf-lua",
         },
      },
   },
   {
      "kyazdani42/nvim-tree.lua",
      dependencies = {
         "kyazdani42/nvim-web-devicons",
      },
      lazy = true,
      keys = {
         { "<leader>e", ":NvimTreeToggle<CR>", { noremap = true } },
      },
      opts = {
         update_focused_file = {
            enable = true,
            update_root = true,
         },
         reload_on_bufenter = true,
         respect_buf_cwd = true,
         view = {
            centralize_selection = true,
            -- side = "right",
         },
      },
      -- <Tab> - preview
      -- `I`               toggle_git_ignored  toggle visibility of files/folders hidden via |git.ignore| option
      -- `H`               toggle_dotfiles     toggle visibility of dotfiles via |filters.dotfiles| option
      -- `a`               create              add a file; leaving a trailing `/` will add a directory
      -- `d`               remove              delete a file (will prompt for confirmation)
      -- `D`               trash               trash a file via |trash| option
      -- `r`               rename              rename a file
      -- `<C-r>`           full_rename         rename a file and omit the filename on input
      -- `x`               cut                 add/remove file/directory to cut clipboard
      -- `c`               copy                add/remove file/directory to copy clipboard
      -- `p`               paste               paste from clipboard; cut clipboard has precedence over copy; will prompt for confirmation
      -- `y`               copy_name           copy name to system clipboard
      -- `Y`               copy_path           copy relative path to system clipboard
      -- `gy`              copy_absolute_path  copy absolute path to system clipboard
      -- `f`               live_filter         live filter nodes dynamically based on regex matching.
      -- `F`               clear_live_filter   clear live filter
      -- `<C-k>`           toggle_file_info    toggle a popup with file infos about the file under the cursor
      -- `W`               collapse_all        collapse the whole tree
      -- `E`               expand_all          expand the whole tree, stopping after expanding |actions.expand_all.max_folder_discovery| folders; this might hang neovim for a while if running on a big folder
   },
   {
      "ibhagwan/fzf-lua",
      dependencies = {
         -- "junegunn/fzf",
         -- "vijaymarupudi/nvim-fzf",
         "kyazdani42/nvim-web-devicons",
         -- "elanmed/fzf-lua-frecency.nvim",
      },
      lazy = false,
      keys = {
         { "<leader>ss", ":FzfLua<CR>", { noremap = true } },
         { "<C-p>", ":FzfLua files<CR>", { noremap = true } },
         { "<leader>rf", ":FzfLua files cwd=$HOME/<CR>", { noremap = true } },
         { "<leader>sn", ":FzfLua files cwd=$HOME/.config/nvim/<CR>", { noremap = true } },
         { "<leader>si", ":FzfLua files cwd=$HOME/.config/<CR>", { noremap = true } },
         { "<leader>sw", ":FzfLua files cwd=$WORKSPACE/notes/<CR>", { noremap = true } },
         { "<leader>f", ":FzfLua git_files<CR>", { noremap = true } },
         { "<leader>`", ":FzfLua buffers<CR>", { noremap = true } },
         { "<leader><leader>", ":FzfLua buffers<CR>", { noremap = true } },
         { "<leader>\\\\", ":FzfLua grep_visual<CR>", { noremap = true } },
         { "\\\\", ":FzfLua live_grep<CR>", { noremap = true } },
         { "//", ":FzfLua blines<CR>", { noremap = true } },
         { "<leader>sq", ":FzfLua quickfix<CR>", { noremap = true } },
         { "gr", ":FzfLua lsp_references<CR>", { noremap = true } },
         { "gm", ":FzfLua lsp_implementations<CR>", { noremap = true } },
         { "<leader>ls", ":FzfLua lsp_document_symbols<CR>", { noremap = true } },
         { "<leader>lS", ":FzfLua lsp_workspace_symbols<CR>", { noremap = true } },
         { "<leader>as", ":FzfLua lsp_code_actions<CR>", { noremap = true } },
         { "<leader>sd", ":FzfLua lsp_document_diagnostics<CR>", { noremap = true } },
         { "<leader>sD", ":FzfLua lsp_workspace_diagnostics<CR>", { noremap = true } },
         { "<leader>sb", ":FzfLua git_branches<CR>", { noremap = true } },
         { "<leader>sc", ":FzfLua git_commits<CR>", { noremap = true } },
         { "<leader>sC", ":FzfLua git_bcommits<CR>", { noremap = true } },
         { "<leader>sm", ":FzfLua marks<CR>", { noremap = true } },
         { "<leader>sx", ":FzfLua commands<CR>", { noremap = true } },
         { "<leader>s:", ":FzfLua command_history<CR>", { noremap = true } },
         { "<leader>s/", ":FzfLua search_history<CR>", { noremap = true } },
         { '<leader>s"', ":FzfLua registers<CR>", { noremap = true } },
         { "<leader>sk", ":FzfLua keymaps<CR>", { noremap = true } },
      },
      opts = function()
         local actions = require("fzf-lua.actions")
         local ripgrep_opts =
            "--column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --max-columns=512 --ignore-file $HOME/.gitignore_global"

         return {
            winopts = {
               height = 0.85,
               width = 0.95,
               row = 0.35,
               col = 0.55,
            },
            actions = {
               files = {
                  ["default"] = actions.file_edit_or_qf,
                  ["ctrl-s"] = actions.file_split,
                  ["ctrl-v"] = actions.file_vsplit,
                  ["ctrl-t"] = actions.file_tabedit,
                  ["ctrl-q"] = actions.file_sel_to_qf,
               },
            },
            files = {
               git_icons = false,
               -- fd seems to work better than rg here
               -- cmd = "rg --files --hidden",
               rg_opts = ripgrep_opts,
               -- adding sorting by created date at the end
               -- fd_opts = [[
               -- --color=auto \
               -- --type f \
               -- --hidden \
               -- --no-ignore \
               -- --follow \
               -- --exclude .git \
               -- --exclude venv \
               -- --exclude .venv \
               -- --exclude .node-gyp \
               -- --exclude .cache \
               -- --exclude .kube \
               -- --exclude .dropbox-dist \
               -- --exclude .mozilla \
               -- --exclude .pyenv \
               -- --exclude .tmux \
               -- --exclude .trash \
               -- --exclude .terraform \
               -- --exclude *.pyc \
               -- --exclude node_modules \
               -- --exclude .mypy_cache \
               -- --exclude vendor \
               -- -X ls -t modified
               -- ]],
            },
            grep = {
               git_icons = false,
               rg_opts = ripgrep_opts,
            },
            lsp = {
               async_or_timeout = 3000,
               git_icons = false,
            },
            quickfix = {
               git_icons = false,
            },
         }
      end,
      config = function(_, opts)
         opts = opts or {}
         require("fzf-lua").setup(opts)
         -- require("fzf-lua-frecency").setup({
         --    cwd_only = true,
         --    display_score = true,
         -- })

         local map = vim.keymap.set
         -- doesn't work with keya mapping
         map("n", "<leader>ws", ":FzfLua grep_cword<CR>", { noremap = true })
         -- map("v", "<leader>ws", ":FzfLua grep_visual<CR>", { noremap = true })

         map("n", "<C-r>", ":lua require('utils').home_fzf()<CR>", { noremap = true })
         map("n", "<leader>rr", ":lua require('utils').home_fzf('fd --type d -i -L')<CR>", { noremap = true })
      end,
   },
   {
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {
         mappings = {
            next = "]m",
            prev = "[m",
         },
      },
      -- mx              Set mark x
      -- m,              Set the next available alphabetical (lowercase) mark
      -- m;              Toggle the next available mark at the current line
      -- dmx             Delete mark x
      -- dm-             Delete all marks on the current line
      -- dm<space>       Delete all marks in the current buffer
      -- m]              Move to next mark
      -- m[              Move to previous mark
      -- m:              Preview mark. This will prompt you for a specific mark to
      --                 preview; press <cr> to preview the next mark.
      --
      -- m[0-9]          Add a bookmark from bookmark group[0-9].
      -- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
      -- m}              Move to the next bookmark having the same type as the bookmark under
      --                 the cursor. Works across buffers.
      -- m{              Move to the previous bookmark having the same type as the bookmark under
      --                 the cursor. Works across buffers.
      -- dm=             Delete the bookmark under the cursor.
   },
}
