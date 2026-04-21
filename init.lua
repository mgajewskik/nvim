-- bootstrap: lazy.nvim
-- ============================================================================

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

-- ============================================================================
-- shared data and helpers
-- ============================================================================

local icons = {
   diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
   },
   git = {
      added = " ",
      modified = " ",
      removed = " ",
   },
   kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = "ﳠ ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
      ReadOnly = " ",
   },
}

local utils = {}

-- Search through home directories and explore without performance issues.
function utils.home_fzf()
   local fzf_lua = require("fzf-lua")
   local opts = {
      cwd = vim.fn.expand("$HOME"),
      prompt = "~ cd $HOME/",
      fn_transform = function(x)
         return fzf_lua.utils.ansi_codes.magenta(x)
      end,
      actions = {
         ["default"] = function(selected)
            fzf_lua.files({ cwd = vim.fn.expand("$HOME/" .. selected[1]) })
         end,
         ["ctrl-d"] = function(selected)
            vim.cmd("cd " .. "$HOME/" .. selected[1])
         end,
         ["ctrl-s"] = function(selected)
            fzf_lua.live_grep({ cwd = vim.fn.expand("$HOME/" .. selected[1]) })
         end,
      },
   }
   fzf_lua.fzf_exec("fd --type d -i -L -E 'venv'", opts)
end

function utils.lsp_on_attach()
   vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
         local map = vim.keymap.set
         local opts = { noremap = true, silent = true }
         local winopts = "{ float =  { border = 'rounded' } }"

         map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
         map("n", "gD", "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<CR>", opts)
         map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
         map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
         map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
         map("n", "[d", ("<cmd>lua vim.diagnostic.goto_prev(%s)<CR>"):format(winopts), opts)
         map("n", "]d", ("<cmd>lua vim.diagnostic.goto_next(%s)<CR>"):format(winopts), opts)
         map("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

         -- This avoids LSP formatting breaking gq behavior.
         vim.bo[args.buf].formatexpr = nil
      end,
   })
end

function utils._echo_multiline(msg)
   for _, s in ipairs(vim.fn.split(msg, "\n")) do
      vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
   end
end

function utils.info(msg)
   vim.cmd("echohl Directory")
   utils._echo_multiline(msg)
   vim.cmd("echohl None")
end

function utils.warn(msg)
   vim.cmd("echohl WarningMsg")
   utils._echo_multiline(msg)
   vim.cmd("echohl None")
end

function utils.err(msg)
   vim.cmd("echohl ErrorMsg")
   utils._echo_multiline(msg)
   vim.cmd("echohl None")
end

function utils.find_qf(kind)
   local win_tbl = {}
   for _, win in pairs(vim.fn.getwininfo()) do
      local found = false
      if kind == "l" and win.loclist == 1 then
         found = true
      end
      if kind == "q" and win.quickfix == 1 and win.loclist == 0 then
         found = true
      end
      if found then
         table.insert(win_tbl, { winid = win.winid, bufnr = win.bufnr })
      end
   end
   return win_tbl
end

function utils.open_qf()
   if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd("copen")
      vim.cmd("wincmd J")
   else
      print("quickfix is empty.")
   end
end

function utils.open_loclist_all()
   for _, win in pairs(vim.fn.getwininfo()) do
      if win.quickfix == 0 then
         if not vim.tbl_isempty(vim.fn.getloclist(win.winnr)) then
            vim.api.nvim_set_current_win(win.winid)
            vim.cmd("lopen")
         else
            print("loclist is empty.")
         end
      end
   end
end

function utils.toggle_qf(kind)
   local windows = utils.find_qf(kind)
   if #windows > 0 then
      for _, win in pairs(windows) do
         vim.api.nvim_win_hide(win.winid)
      end
      return
   end

   if kind == "l" then
      utils.open_loclist_all()
   else
      utils.open_qf()
   end
end

function utils.sudo_exec(cmd, print_output)
   local password = vim.fn.inputsecret("Password: ")
   if not password or #password == 0 then
      utils.warn("Invalid password, sudo aborted")
      return false
   end

   local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
   if vim.v.shell_error ~= 0 then
      print("\r\n")
      utils.err(out)
      return false
   end

   if print_output then
      print("\r\n", out)
   end
   return true
end

function utils.sudo_write(tmpfile, filepath)
   tmpfile = tmpfile or vim.fn.tempname()
   filepath = filepath or vim.fn.expand("%")
   if not filepath or #filepath == 0 then
      utils.err("E32: No file name")
      return
   end

   -- `bs=1048576` is portable across GNU/BSD dd.
   local cmd = string.format("dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
   vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
   if utils.sudo_exec(cmd) then
      utils.info(string.format('\r\n"%s" written', filepath))
      vim.cmd("e!")
   end
   vim.fn.delete(tmpfile)
end

function utils.jump_to_word(ignore_underscore)
   local search = require("leap.search")
   local modify_keyword = false
   local ch = vim.fn.getcharstr()

   if ch == " " then
      print("Must insert a non-whitespace character")
      return
   end

   local pattern = string.format("\\V%s", ch)
   if ch:match("[a-z0-9]") then
      pattern = string.format("\\<%s", ch)
      modify_keyword = ignore_underscore
   elseif ch:match("[A-Z]") then
      pattern = ([[\<%s\|\<%s\|[a-z]\@<=%s]]):format(ch:lower(), ch, ch)
      modify_keyword = ignore_underscore
   end

   if modify_keyword then
      vim.opt.iskeyword:remove("_")
   end

   local winid = vim.api.nvim_get_current_win()
   local targets = search["get-targets"](pattern, { ["target-windows"] = { winid } })

   if modify_keyword then
      vim.opt.iskeyword:append("_")
   end

   if targets == nil then
      print("No targets found")
      return
   end

   require("leap").leap({ targets = targets })
end

local function augroup(name, callback)
   callback(vim.api.nvim_create_augroup(name, { clear = true }))
end

-- ============================================================================
-- core options
-- ============================================================================

local o = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

o.syntax = "on"
o.clipboard = "unnamedplus"
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2
o.confirm = true
o.cursorline = true
o.expandtab = true
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
o.ignorecase = true
o.inccommand = "nosplit"
o.laststatus = 0
o.mouse = "a"
o.number = false
o.pumblend = 10
o.pumheight = 10
o.relativenumber = false
o.scrolloff = 4
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
o.shiftround = true
o.shiftwidth = 4
o.shortmess:append({ W = true, I = true, c = true })
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.autoindent = true
o.spelllang = { "en" }
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.termguicolors = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.autoread = true
o.wildmode = "longest:full,full"
o.winminwidth = 5
o.wrap = true

if vim.fn.has("nvim-0.9.0") == 1 then
   o.splitkeep = "screen"
   o.shortmess:append({ C = true })
end

o.list = false
o.listchars = {
   tab = ">-",
}
o.showbreak = "↪ "

o.fillchars = {
   horiz = "━",
   horizup = "┻",
   horizdown = "┳",
   vert = "┃",
   vertleft = "┫",
   vertright = "┣",
   verthoriz = "╋",
}

-- Keep comment continuation sensible; `o` is removed again in autocmds.
o.formatoptions = "jcroqlnt"

vim.g.markdown_recommended_style = 0

o.backup = false
o.writebackup = false
o.swapfile = false

-- ============================================================================
-- filetype-specific settings
-- ============================================================================

augroup("AutoBashType", function(g)
   vim.api.nvim_create_autocmd("BufReadPost", {
      group = g,
      pattern = "*",
      callback = function(event)
         vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) and vim.bo[event.buf].filetype == "" then
               vim.bo[event.buf].filetype = "bash"
            end
         end)
      end,
   })
end)

augroup("JSON", function(g)
   vim.api.nvim_create_autocmd("FileType", {
      group = g,
      pattern = { "json" },
      callback = function()
         vim.opt_local.tabstop = 2
         vim.opt_local.shiftwidth = 2
         vim.opt_local.softtabstop = 2
      end,
   })
end)

augroup("YAMLAndVim", function(g)
   vim.api.nvim_create_autocmd("FileType", {
      group = g,
      pattern = { "yaml", "vim" },
      callback = function()
         vim.opt_local.tabstop = 2
         vim.opt_local.shiftwidth = 2
         vim.opt_local.softtabstop = 2
      end,
   })
end)

augroup("LuaIndent", function(g)
   vim.api.nvim_create_autocmd("FileType", {
      group = g,
      pattern = { "lua" },
      callback = function()
         vim.opt_local.tabstop = 3
         vim.opt_local.shiftwidth = 3
         vim.opt_local.softtabstop = 3
      end,
   })
end)

augroup("Markdown", function(g)
   vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
      group = g,
      pattern = { "markdown", "telekasten" },
      callback = function()
         vim.opt_local.wrap = true
         vim.opt_local.spell = false
         vim.opt_local.conceallevel = 2
         vim.opt_local.formatoptions = "jcrqn"
         vim.opt_local.tabstop = 2
         vim.opt_local.softtabstop = 2
         vim.opt_local.shiftwidth = 2
      end,
   })
end)

augroup("GitCommit", function(g)
   vim.api.nvim_create_autocmd("FileType", {
      group = g,
      pattern = { "gitcommit" },
      callback = function()
         vim.opt_local.spell = true
         vim.opt_local.textwidth = 72
      end,
   })
end)

augroup("QuickClose", function(g)
   vim.api.nvim_create_autocmd("FileType", {
      group = g,
      pattern = {
         "qf",
         "man",
         "help",
         "guihua",
         "notify",
         "lspinfo",
         "fugitive",
         "startuptime",
         "null-ls-info",
         "tsplayground",
         "spectre_panel",
         "PlenaryTestPopup",
      },
      callback = function(event)
         vim.bo[event.buf].buflisted = false
         vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
      end,
   })
end)

-- ============================================================================
-- autocmds
-- ============================================================================

augroup("HighlightYankedText", function(g)
   vim.api.nvim_create_autocmd("TextYankPost", {
      group = g,
      callback = function()
         vim.highlight.on_yank()
      end,
   })
end)

augroup("Fugitive", function(g)
   vim.api.nvim_create_autocmd("BufReadPost", {
      group = g,
      pattern = "fugitive://*",
      command = "set bufhidden=delete",
   })
end)

augroup("NoNewlineNoAutoComments", function(g)
   vim.api.nvim_create_autocmd("BufEnter", {
      group = g,
      pattern = "*",
      command = "setlocal formatoptions-=cro",
   })
end)

-- This can be annoying for Go templates, so keep the caveat visible.
augroup("TrimWhiteSpaceGrp", function(g)
   vim.api.nvim_create_autocmd("BufWritePre", {
      group = g,
      pattern = "*",
      command = [[:%s/\s\+$//e]],
   })
end)

augroup("TrimNewLinesGrp", function(g)
   vim.api.nvim_create_autocmd("BufWritePre", {
      group = g,
      pattern = "*",
      command = [[:%s/\($\n\s*\)\+\%$//e]],
   })
end)

augroup("AutoResize", function(g)
   vim.api.nvim_create_autocmd("VimResized", {
      group = g,
      callback = function()
         vim.cmd("tabdo wincmd =")
      end,
   })
end)

-- ============================================================================
-- keymaps and user commands
-- ============================================================================

vim.api.nvim_create_user_command("SudoWriteCurrent", function()
   utils.sudo_write()
end, { desc = "Write current file with sudo" })

local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }

map("n", "<C-s>", function()
   utils.jump_to_word(false)
end, default_opts)

map("n", "<leader>ll", "<cmd>:Lazy<cr>", default_opts)

map("i", "jj", "<Esc>l", default_opts)
map("i", "jk", "<Esc>l", default_opts)
map("i", "kj", "<Esc>l", default_opts)

map("c", "w!!", "<esc><cmd>SudoWriteCurrent<CR>", default_opts)

map("t", "<C-w>e", [[<C-\><C-n>]], default_opts)
map("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], expr_opts)
map("n", "<leader>tt", ":tabnew<CR>:terminal<CR>i", default_opts)

map("n", "<C-h>", ":wincmd h<CR>", default_opts)
map("n", "<C-l>", ":wincmd l<CR>", default_opts)

map("n", "<leader>1", "1gt", default_opts)
map("n", "<leader>2", "2gt", default_opts)
map("n", "<leader>3", "3gt", default_opts)
map("n", "<leader>4", "4gt", default_opts)
map("n", "<leader>5", "5gt", default_opts)
map("n", "<leader>6", "6gt", default_opts)
map("n", "<leader>7", "7gt", default_opts)
map("n", "<leader>8", "8gt", default_opts)
map("n", "<leader>9", "9gt", default_opts)
map("n", "<Leader>tn", ":tabnew<CR>", default_opts)
map("n", "<Leader>tc", ":tabclose<CR>", default_opts)
map("n", "<Leader>to", ":tabonly<CR>", default_opts)
map("n", "<Leader>tO", ":tabfirst<CR>:tabonly<CR>", default_opts)

map("n", "[b", ":bprevious<CR>", default_opts)
map("n", "]b", ":bnext<CR>", default_opts)
map("n", "[B", ":bfirst<CR>", default_opts)
map("n", "]B", ":blast<CR>", default_opts)

map("n", "<leader>q", function()
   utils.toggle_qf("q")
end, { noremap = true })
map("n", "<C-k>", ":cp<CR>", { noremap = true })
map("n", "<C-j>", ":cn<CR>", { noremap = true })
map("n", "[q", ":cprevious<CR>", default_opts)
map("n", "]q", ":cnext<CR>", default_opts)
map("n", "[Q", ":cfirst<CR>", default_opts)
map("n", "]Q", ":clast<CR>", default_opts)

map("n", "<leader>Q", function()
   utils.toggle_qf("l")
end, { noremap = true })
map("n", "[l", ":lprevious<CR>", default_opts)
map("n", "]l", ":lnext<CR>", default_opts)
map("n", "[L", ":lfirst<CR>", default_opts)
map("n", "]L", ":llast<CR>", default_opts)

map("n", "d", '"_d', default_opts)
map("n", "<leader>d", "d", default_opts)
map("v", "d", '"_d', default_opts)
map("v", "<leader>d", "d", default_opts)
map("n", "<leader>D", '"_D', default_opts)
map("n", "<leader>c", '"_c', default_opts)
map("n", "<leader>C", '"_C', default_opts)
map("v", "<leader>c", '"_c', default_opts)

map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

map("x", "K", ":move '<-2<CR>gv=gv", default_opts)
map("x", "J", ":move '>+1<CR>gv=gv", default_opts)

map("n", "g<C-v>", "`[v`]", default_opts)

for _, c in ipairs({ "j", "k" }) do
   map("n", c, ([[ (v:count > 5 ? "m'" . v:count : "") . '%s' ]]):format(c), expr_opts)
end

map("n", "c.", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], default_opts)
map("n", "<leader>c.", [[:%s/\<<C-r><C-a>\>//g<Left><Left>]], default_opts)

map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR>", default_opts)
map("n", "<leader>/", "<Esc>:nohlsearch<CR>", default_opts)

map("n", "<leader><CR>", "o<Esc>", default_opts)
map("n", "<leader>O", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', default_opts)

map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- ============================================================================
-- plugin specs
-- ============================================================================

local plugins = {
   {
      "rebelot/kanagawa.nvim",
      lazy = false,
      priority = 1000,
      config = function()
         require("kanagawa").setup({
            overrides = function()
               return {
                  Search = { fg = "#0F1F28", bg = "#FF9E3B" },
                  Visual = { bg = "#54546D" },
                  SignColumn = { bg = "#1F1F28" },
                  LineNr = { bg = "#1F1F28" },
               }
            end,
         })
         vim.cmd("colorscheme kanagawa")
      end,
   },
   {
      "nvim-lua/plenary.nvim",
      lazy = true,
   },
   {
      "tpope/vim-obsession",
      lazy = false,
   },
   {
      "lambdalisue/suda.vim",
      cmd = {
         "SudaRead",
         "SudaWrite",
      },
   },
   {
      "tpope/vim-surround",
      event = "VeryLazy",
   },
   {
      "tommcdo/vim-lion",
   },
   {
      "mbbill/undotree",
      keys = {
         { "<leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>", { noremap = true } },
      },
   },
   {
      "kevinhwang91/nvim-fundo",
      dependencies = { "kevinhwang91/promise-async" },
      config = function()
         require("fundo").install()
      end,
   },
   {
      "echasnovski/mini.comment",
      event = "VeryLazy",
      config = function()
         require("mini.comment").setup()
      end,
   },
   {
      "echasnovski/mini.pairs",
      event = "VeryLazy",
      opts = {
         mappings = {
            ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%a\\].", register = { cr = false } },
            ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
            ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%a\\].", register = { cr = false } },
         },
      },
      config = function(_, opts)
         require("mini.pairs").setup(opts)
      end,
   },
   {
      "echasnovski/mini.ai",
      event = "VeryLazy",
      config = function()
         require("mini.ai").setup()
      end,
   },
   {
      "LunarVim/bigfile.nvim",
      event = "VeryLazy",
      config = true,
   },
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
         },
      },
   },
   {
      "ibhagwan/fzf-lua",
      dependencies = {
         "kyazdani42/nvim-web-devicons",
      },
      lazy = false,
      keys = {
         { "<leader>ss", ":FzfLua<CR>", { noremap = true } },
         { "<C-p>", ":FzfLua files<CR>", { noremap = true } },
         { "<leader>rf", ":FzfLua files cwd=$HOME/<CR>", { noremap = true } },
         { "<leader>sn", ":FzfLua files cwd=$HOME/.config/nvim/<CR>", { noremap = true } },
         { "<leader>si", ":FzfLua files cwd=$HOME/.config/<CR>", { noremap = true } },
         { "<leader>sw", ":FzfLua files cwd=$HOME/notes/<CR>", { noremap = true } },
         { "<leader>f", ":FzfLua git_files<CR>", { noremap = true } },
         { "<leader>`", ":FzfLua buffers<CR>", { noremap = true } },
         { "<leader><leader>", ":FzfLua buffers<CR>", { noremap = true } },
         { "<leader>\\", ":FzfLua grep_visual<CR>", { noremap = true } },
         { "\\", ":FzfLua live_grep<CR>", { noremap = true } },
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
               rg_opts = ripgrep_opts,
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
         require("fzf-lua").setup(opts or {})
         local notes_cwd = vim.fn.expand("$HOME/notes")

         vim.keymap.set("n", "<leader>ws", ":FzfLua grep_cword<CR>", { noremap = true })
         vim.keymap.set("n", "<C-r>", function()
            utils.home_fzf()
         end, { noremap = true })
         vim.keymap.set("n", "<leader>rr", function()
            utils.home_fzf()
         end, { noremap = true })
         vim.keymap.set("n", "<leader>zf", function()
            require("fzf-lua").files({ cwd = notes_cwd })
         end, { noremap = true, silent = true, desc = "Notes files" })
         vim.keymap.set("n", "<leader>zs", function()
            require("fzf-lua").live_grep({ cwd = notes_cwd })
         end, { noremap = true, silent = true, desc = "Notes grep" })
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
   },
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
   {
      "ray-x/go.nvim",
      dependencies = {
         "ray-x/guihua.lua",
         "neovim/nvim-lspconfig",
         "nvim-treesitter/nvim-treesitter",
      },
      lazy = true,
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()',
      opts = {
         remap_commands = {
            GoDoc = false,
         },
         lsp_cfg = true,
         lsp_gofumpt = true,
         lsp_codelens = false,
         lsp_keymaps = false,
         lsp_diag_update_in_insert = true,
         lsp_document_formatting = false,
         dap_debug_keymap = false,
         icons = { breakpoint = "B", currentpos = "C" },
         build_tags = "",
         run_in_floaterm = true,
         lsp_inlay_hints = {
            -- `false` here still errors during setup, so the plugin expects enable=false.
            enable = false,
         },
      },
   },
   {
      "hashivim/vim-terraform",
      config = function()
         vim.g.terraform_align = 1
         vim.g.terraform_fold_sections = 0
         vim.g.terraform_fmt_on_save = 1
         vim.g.hcl_align = 1
      end,
   },
   {
      "stevearc/conform.nvim",
      opts = {
         formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_fix", "ruff_organize_imports" },
            go = { "goimports" },
            json = { "jq" },
            yaml = { "yamlfmt" },
            sh = { "shfmt" },
            sql = { "pg_format" },
            gohtmltmpl = { "djlint" },
            hcl = { "terraform_fmt" },
         },
         notify_on_error = true,
         format_on_save = function(bufnr)
            if vim.bo[bufnr].filetype == "yaml" then
               vim.b[bufnr].disable_autoformat = true
            end
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
               return
            end
            return { timeout_ms = 1000, lsp_format = "never" }
         end,
      },
      config = function(_, opts)
         local util = require("conform.util")
         require("conform").setup(opts)

         local jq = require("conform.formatters.jq")
         require("conform").formatters.jq = vim.tbl_deep_extend("force", jq, {
            args = util.extend_args(jq.args, { "--indent", "2" }),
         })

         local stylua = require("conform.formatters.stylua")
         require("conform").formatters.stylua = vim.tbl_deep_extend("force", stylua, {
            args = util.extend_args(stylua.args, { "--indent-width", "3", "--indent-type", "Spaces" }),
         })

         vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
               vim.b.disable_autoformat = true
            else
               vim.g.disable_autoformat = true
            end
         end, {
            desc = "Disable autoformat-on-save",
            bang = true,
         })

         vim.api.nvim_create_user_command("FormatEnable", function(args)
            if args.bang then
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
            yaml = { "yamllint" },
            go = { "revive" },
            lua = { "luacheck" },
            sh = { "shellcheck" },
            terraform = { "tfsec" },
            dockerfile = { "hadolint" },
            json = { "jsonlint" },
            sql = { "sqlfluff" },
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
      "mason-org/mason.nvim",
      cmd = "Mason",
      build = ":MasonUpdate",
      opts = {
         ensure_installed = {
            "actionlint",
            "cfn-lint",
            "yamllint",
            "revive",
            "luacheck",
            "tfsec",
            "hadolint",
            "jsonlint",
            "sqlfluff",
            "protolint",
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
         mr.refresh(function()
            for _, tool in ipairs(opts.ensure_installed) do
               local p = mr.get_package(tool)
               if not p:is_installed() then
                  p:install()
               end
            end
         end)
      end,
   },
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
            jsonls = {},
            yamlls = {
               settings = {
                  yaml = {
                     keyOrdering = false,
                  },
               },
            },
            bashls = {},
            dockerls = {},
            gopls = {
               cmd = { "gopls", "-remote=auto" },
               settings = {
                  telemetry = { enable = false },
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
            },
            stylua = { enabled = false },
            lua_ls = {
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
            pyright = { enabled = false },
            ty = {},
            ruff = {
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
            marksman = { enabled = false },
            vimls = {},
            buf_ls = {},
            hyprls = {
               filetypes = { "*.hl", "hypr*.conf" },
            },
            ts_ls = {},
         },
         setup = {},
      },
      config = function(_, opts)
         utils.lsp_on_attach()

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
         local mason_exclude = {}

         local function configure(server)
            if server == "*" then
               return false
            end
            local sopts = opts.servers[server]
            sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts
            sopts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, sopts.capabilities or {})

            if sopts.enabled == false then
               mason_exclude[#mason_exclude + 1] = server
               return
            end

            local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
            local setup = opts.setup[server] or opts.setup["*"]
            if setup and setup(server, sopts) then
               mason_exclude[#mason_exclude + 1] = server
            else
               vim.lsp.config(server, sopts)
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
      "saghen/blink.cmp",
      dependencies = {
         "mikavilpas/blink-ripgrep.nvim",
         "moyiz/blink-emoji.nvim",
         { "saghen/blink.compat", lazy = true, version = false },
      },
      version = "v1",
      opts = {
         completion = {
            accept = { auto_brackets = { enabled = true }, dot_repeat = false },
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = {
               auto_show = true,
               auto_show_delay_ms = 250,
               treesitter_highlighting = false,
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
               local cmd_type = vim.fn.getcmdtype()
               if cmd_type == "/" or cmd_type == "?" then
                  return { "buffer" }
               end
               if cmd_type == ":" then
                  return { "cmdline" }
               end
               return {}
            end,
         },
         sources = {
            default = function()
               local cwd = vim.fn.getcwd()
               if cwd == vim.fn.expand("$HOME") or cwd == vim.fn.expand("$HOME/.config") then
                  return { "lsp", "path", "buffer" }
               end
               return { "lsp", "path", "buffer", "ripgrep" }
            end,
            providers = {
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
                           additional_rg_options = { "--ignore-file $HOME/.gitignore_global" },
                           max_filesize = "1M",
                           search_casing = "--smart-case",
                        },
                     },
                  },
               },
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  score_offset = 100,
               },
               emoji = {
                  module = "blink-emoji",
                  name = "Emoji",
                  score_offset = 15,
                  opts = { insert = true },
               },
            },
         },
      },
   },
   {
      "tpope/vim-fugitive",
      lazy = true,
      keys = {
         { "<leader>sg", "<Esc>:Git<CR>", { noremap = true } },
         { "<leader>gb", "<Esc>:Git blame<CR>", { noremap = true } },
         { "<leader>gc", "<Esc>:Git commit<CR>", { noremap = true } },
         { "<leader>gv", "<Esc>:Gvdiffsplit!<CR>", { noremap = true } },
         { "<leader>gl", "<Esc>:Git log --graph --abbrev-commit --decorate<CR>", { noremap = true } },
         { "<leader>sr", "<Esc>:Git rebase -i HEAD~20<CR>", { noremap = true } },
         { "<leader>gh", "<Esc>:diffget //3<CR>", { noremap = true } },
         { "<leader>gf", "<Esc>:diffget //2<CR>", { noremap = true } },
      },
   },
   {
      "lewis6991/gitsigns.nvim",
      config = true,
   },
   {
      "sindrets/diffview.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      lazy = true,
      cmd = {
         "DiffviewOpen",
         "DiffviewFileHistory",
      },
      keys = {
         { "<leader>gdh", ":DiffviewFileHistory %<CR>", { noremap = true } },
         { "<leader>gdd", ":DiffviewOpen origin/master", { noremap = true } },
         { "<leader>gds", ":DiffviewOpen --staged", { noremap = true } },
      },
      config = true,
   },
   {
      "NeogitOrg/neogit",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "sindrets/diffview.nvim",
         "ibhagwan/fzf-lua",
      },
      lazy = true,
      cmd = "Neogit",
      keys = {
         { "<leader>gs", ":Neogit<CR>", { noremap = true, silent = true } },
      },
      opts = {
         integrations = {
            diffview = true,
            fzf_lua = true,
         },
      },
   },
   {
      "pwntester/octo.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-telescope/telescope.nvim",
         "kyazdani42/nvim-web-devicons",
      },
      lazy = true,
      cmd = "Octo",
      keys = {
         { "<leader>gp", ":Octo pr list<CR>", { noremap = true, silent = true } },
      },
      config = function()
         require("octo").setup()
      end,
   },
   {
      "akinsho/toggleterm.nvim",
      lazy = true,
      keys = {
         { "<C-\\>", ":ToggleTerm<CR>", { noremap = true } },
      },
      opts = {
         open_mapping = [[<C-\>]],
         shading_factor = "1",
         direction = "float",
         float_opts = {
            border = "rounded",
            winblend = 5,
         },
      },
   },
   {
      "echasnovski/mini.indentscope",
      opts = {
         draw = {
            delay = 10,
            animation = function()
               return 5
            end,
         },
         mappings = {
            object_scope = "ii",
            object_scope_with_border = "ai",
            goto_top = "[i",
            goto_bottom = "]i",
         },
         options = {
            try_as_border = true,
         },
         symbol = "╎",
      },
      config = function(_, opts)
         require("mini.indentscope").setup(opts)
      end,
   },
   {
      "nvim-lualine/lualine.nvim",
      dependencies = {
         "kyazdani42/nvim-web-devicons",
      },
      opts = function()
         return {
            options = {
               theme = "kanagawa",
               icons_enabled = true,
               disabled_filetypes = {},
               always_divide_middle = false,
            },
            sections = {
               lualine_a = { "branch" },
               lualine_b = {},
               lualine_c = {
                  {
                     "diagnostics",
                     sources = { "nvim_diagnostic" },
                     symbols = {
                        error = icons.diagnostics.Error,
                        warn = icons.diagnostics.Warn,
                        info = icons.diagnostics.Info,
                        hint = icons.diagnostics.Hint,
                     },
                  },
                  {
                     "filetype",
                     icon_only = true,
                  },
                  {
                     "filename",
                     file_status = true,
                     path = 1,
                     shorting_target = 40,
                     symbols = {
                        modified = icons.git.added,
                        readonly = icons.kinds.ReadOnly,
                     },
                  },
               },
               lualine_x = {
                  "encoding",
                  "fileformat",
                  "filesize",
               },
               lualine_y = { "progress" },
               lualine_z = { "location" },
            },
            inactive_sections = {
               lualine_a = {},
               lualine_b = {},
               lualine_c = { "filename" },
               lualine_x = { "location" },
               lualine_y = {},
               lualine_z = {},
            },
            tabline = {},
            extensions = { "nvim-tree", "toggleterm", "quickfix", "symbols-outline" },
         }
      end,
   },
}

-- ============================================================================
-- lazy setup
-- ============================================================================

require("lazy").setup(plugins, {
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
