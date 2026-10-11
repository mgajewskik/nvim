-- Leap to the start of a word beginning with the typed character
-- https://www.reddit.com/r/neovim/comments/16aan6k/comment/jz6maht/
local function leap_to_word()
   local ch = vim.fn.getcharstr()
   if ch == " " then
      print("Must insert a non-whitespace character")
      return
   end

   local pattern = string.format("\\V%s", ch)
   if ch:match("[a-z0-9]") then
      pattern = string.format("\\<%s", ch)
   elseif ch:match("[A-Z]") then
      pattern = ([[\<%s\|\<%s\|[a-z]\@<=%s]]):format(ch:lower(), ch, ch)
   end

   local targets = require("leap.search").get_targets(pattern, {
      windows = { vim.api.nvim_get_current_win() },
      inputlen = 1,
   })
   if targets == nil then
      print("No targets found")
      return
   end
   require("leap").leap({ targets = targets })
end

-- Pick a directory under $HOME, then: enter = find files, ctrl-d = cd, ctrl-s = grep
local function home_dirs()
   local fzf_lua = require("fzf-lua")
   local home = vim.fn.expand("$HOME")
   fzf_lua.fzf_exec("fd --type d -i -L -E 'venv'", {
      cwd = home,
      prompt = "~ cd $HOME/",
      fn_transform = function(x)
         return fzf_lua.utils.ansi_codes.magenta(x)
      end,
      actions = {
         ["default"] = function(selected)
            fzf_lua.files({ cwd = home .. "/" .. selected[1] })
         end,
         ["ctrl-d"] = function(selected)
            vim.cmd.cd(home .. "/" .. selected[1])
         end,
         ["ctrl-s"] = function(selected)
            fzf_lua.live_grep({ cwd = home .. "/" .. selected[1] })
         end,
      },
   })
end

return {
   {
      url = "https://codeberg.org/andyg/leap.nvim",
      event = "VeryLazy",
      config = function()
         -- leap_to_word searches both directions, so no S; visual S belongs to vim-surround
         vim.keymap.set({ "n", "x", "o" }, "s", leap_to_word, { silent = true })
      end,
   },
   {
      "ggandor/flit.nvim",
      dependencies = { { url = "https://codeberg.org/andyg/leap.nvim" } },
      event = "VeryLazy",
      opts = {},
   },
   {
      "mikavilpas/yazi.nvim",
      dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
      keys = {
         { "<C-e>", "<cmd>Yazi<CR>", desc = "Open yazi at the current file" },
      },
      opts = {
         open_for_directories = true,
         keymaps = { change_working_directory = "<c-d>" },
         floating_window_scaling_factor = 0.7,
         integrations = {
            grep_in_selected_files = "fzf-lua",
            grep_in_directory = "fzf-lua",
         },
      },
   },
   {
      "kyazdani42/nvim-tree.lua",
      dependencies = { "kyazdani42/nvim-web-devicons" },
      keys = {
         { "<leader>e", "<cmd>NvimTreeToggle<CR>" },
      },
      opts = {
         update_focused_file = {
            enable = true,
            update_root = true,
         },
         reload_on_bufenter = true,
         respect_buf_cwd = true,
         view = { centralize_selection = true },
      },
   },
   {
      "ibhagwan/fzf-lua",
      dependencies = { "kyazdani42/nvim-web-devicons" },
      lazy = false,
      keys = {
         { "<leader>ss", "<cmd>FzfLua<CR>" },
         { "<C-p>", "<cmd>FzfLua files<CR>" },
         { "<leader>f", "<cmd>FzfLua git_files<CR>" },
         { "<leader>rf", "<cmd>FzfLua files cwd=$HOME/<CR>" },
         { "<leader>sn", "<cmd>FzfLua files cwd=$HOME/.config/nvim/<CR>" },
         { "<leader>si", "<cmd>FzfLua files cwd=$HOME/.config/<CR>" },
         { "<leader>sw", "<cmd>FzfLua files cwd=$WORKSPACE/notes/<CR>" },
         { "<C-r>", home_dirs },
         { "<leader>rr", home_dirs },
         { "<leader>`", "<cmd>FzfLua buffers<CR>" },
         { "<leader><leader>", "<cmd>FzfLua buffers<CR>" },
         { "\\\\", "<cmd>FzfLua live_grep<CR>" },
         { "<leader>\\\\", "<cmd>FzfLua grep_visual<CR>" },
         { "<leader>ws", "<cmd>FzfLua grep_cword<CR>" },
         { "//", "<cmd>FzfLua blines<CR>" },
         { "<leader>sq", "<cmd>FzfLua quickfix<CR>" },
         { "<leader>sb", "<cmd>FzfLua git_branches<CR>" },
         { "<leader>sc", "<cmd>FzfLua git_commits<CR>" },
         { "<leader>sC", "<cmd>FzfLua git_bcommits<CR>" },
         { "<leader>sm", "<cmd>FzfLua marks<CR>" },
         { "<leader>sx", "<cmd>FzfLua commands<CR>" },
         { "<leader>s:", "<cmd>FzfLua command_history<CR>" },
         { "<leader>s/", "<cmd>FzfLua search_history<CR>" },
         { '<leader>s"', "<cmd>FzfLua registers<CR>" },
         { "<leader>sk", "<cmd>FzfLua keymaps<CR>" },
         -- LSP pickers; grr/gri replace the built-in quickfix versions
         { "grr", "<cmd>FzfLua lsp_references<CR>" },
         { "gri", "<cmd>FzfLua lsp_implementations<CR>" },
         { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<CR>" },
         { "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<CR>" },
         { "<leader>as", "<cmd>FzfLua lsp_code_actions<CR>" },
         { "<leader>sd", "<cmd>FzfLua lsp_document_diagnostics<CR>" },
         { "<leader>sD", "<cmd>FzfLua lsp_workspace_diagnostics<CR>" },
      },
      opts = function()
         local actions = require("fzf-lua.actions")
         return {
            winopts = {
               height = 0.85,
               width = 0.95,
               row = 0.35,
               col = 0.55,
            },
            actions = {
               -- true: keep the default file actions
               files = { true, ["ctrl-q"] = actions.file_sel_to_qf },
            },
            files = {
               -- fzf-lua prefers fd over rg when available; rg_opts alone never applied
               no_ignore = true,
               fd_opts = [[--color=never --type f --type l --no-ignore --hidden --exclude .git]],
               rg_opts = [[--color=never --files --no-ignore --hidden -g "!.git"]],
            },
            grep = {
               rg_opts = "--column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --max-columns=512 --ignore-file $HOME/.config/git/ignore",
            },
            lsp = { async_or_timeout = 3000 },
         }
      end,
   },
}
