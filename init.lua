-- Options

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.markdown_recommended_style = 0

local o = vim.opt
o.clipboard = "unnamedplus"
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2
o.confirm = true
o.cursorline = true
o.expandtab = true
o.fillchars = {
   horiz = "━",
   horizup = "┻",
   horizdown = "┳",
   vert = "┃",
   vertleft = "┫",
   vertright = "┣",
   verthoriz = "╋",
}
o.formatoptions = "jcroqlnt"
o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
o.ignorecase = true
o.listchars = { tab = ">-" }
o.mouse = "a"
o.pumblend = 10
o.pumheight = 10
o.scrolloff = 4
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
o.shiftround = true
o.shiftwidth = 4
o.shortmess:append({ W = true, I = true, c = true })
o.showbreak = "↪ "
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitkeep = "screen"
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.termguicolors = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.wildmode = "longest:full,full"
o.winminwidth = 5
o.writebackup = false

-- Built-in message UI (experimental in 0.12): messages show in a timed popup instead of the cmdline
require("vim._core.ui2").enable({ msg = { targets = "msg" } })

-- Keymaps

local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>ll", "<cmd>Lazy<CR>", opts)
map("n", "<leader>u", function()
   vim.cmd.packadd("nvim.undotree")
   vim.cmd.Undotree()
end, opts)

for _, keys in ipairs({ "jj", "jk", "kj" }) do
   map("i", keys, "<Esc>l", opts)
end

map("c", "w!!", "<Esc>:SudaWrite<CR>", opts)

-- Terminal
map("t", "<C-w>e", [[<C-\><C-n>]], opts)
map("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { silent = true, expr = true })
map("n", "<leader>tt", ":tabnew<CR>:terminal<CR>i", opts)
map("n", "<leader>ts", function()
   local file = vim.fn.expand("%:p")
   if file == "" then
      vim.notify("No file name", vim.log.levels.WARN)
      return
   end
   vim.cmd("tab terminal presenterm " .. vim.fn.shellescape(file))
   vim.defer_fn(function()
      vim.cmd("startinsert")
   end, 10)
end, { desc = "New tab → presenterm current file" })

-- Windows and tabs
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
for i = 1, 9 do
   map("n", "<leader>" .. i, i .. "gt", opts)
end
map("n", "<leader>tn", ":tabnew<CR>", opts)
map("n", "<leader>tc", ":tabclose<CR>", opts)
map("n", "<leader>to", ":tabonly<CR>", opts)
-- Jump to first tab & close all other tabs. Helpful after running Git difftool.
map("n", "<leader>tO", ":tabfirst<CR>:tabonly<CR>", opts)

-- 'd' and 'c' don't pollute the unnamed register; <leader>d is the real delete
map({ "n", "v" }, "d", '"_d', opts)
map({ "n", "v" }, "<leader>d", "d", opts)
map("n", "<leader>D", '"_D', opts)
map({ "n", "v" }, "<leader>c", '"_c', opts)
map("n", "<leader>C", '"_C', opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("x", "K", ":move '<-2<CR>gv=gv", opts)
map("x", "J", ":move '>+1<CR>gv=gv", opts)
-- Select last pasted/yanked text
map("n", "g<C-v>", "`[v`]", opts)

-- n always searches forward, N backward
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Jumps over 5 lines go to the jumplist, so <C-o>/<C-i> work on them
for _, c in ipairs({ "j", "k" }) do
   map("n", c, ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c), { silent = true, expr = true })
end

-- Replace the word under the cursor: 'c.' in this file, '<leader>c.' in every file
-- of the quickfix list. Not silent: the cmdline must show.
map("n", "c.", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])
map("n", "<leader>c.", [[:cfdo %s/\<<C-r><C-w>\>//ge | update]] .. string.rep("<Left>", 12))

map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR>", opts)
map("n", "<leader>/", "<Esc>:nohlsearch<CR>", opts)

map("n", "<leader><CR>", "o<Esc>", opts)
map("n", "<leader>O", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', opts)

-- Plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
   vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
   change_detection = { enabled = false },
   performance = {
      rtp = {
         disabled_plugins = { "netrwPlugin", "gzip", "zipPlugin", "tarPlugin", "fzf" },
      },
   },
})

-- Autocommands: after lazy.setup, which loads filetype detection the bash fallback below relies on

local group = vim.api.nvim_create_augroup("config", { clear = true })
local function autocmd(event, pattern, callback)
   vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
end

autocmd("TextYankPost", "*", function()
   vim.hl.on_yank()
end)

-- Equalize splits in every tab when the terminal resizes; tabdo ends on the last tab, so go back
autocmd("VimResized", "*", function()
   local tab = vim.api.nvim_get_current_tabpage()
   vim.cmd("tabdo wincmd =")
   vim.api.nvim_set_current_tabpage(tab)
end)

-- On save: strip trailing whitespace (not where it is meaningful) and trailing blank lines
local keep_trailing_whitespace = { markdown = true, gohtmltmpl = true, gotexttmpl = true }
autocmd("BufWritePre", "*", function()
   local view = vim.fn.winsaveview()
   if not keep_trailing_whitespace[vim.bo.filetype] then
      vim.cmd([[keeppatterns %s/\s\+$//e]])
   end
   vim.cmd([[keeppatterns %s/\($\n\s*\)\+\%$//e]])
   vim.fn.winrestview(view)
end)

autocmd("BufReadPost", "fugitive://*", function()
   vim.bo.bufhidden = "delete"
end)

autocmd("BufReadPost", "*", function()
   if vim.bo.filetype == "" then
      vim.bo.filetype = "bash"
   end
end)

-- Terraform/HCL files the built-in detection misses (vim-terraform used to cover these);
-- *.tfvars stays the built-in terraform-vars, which terraformls understands
vim.filetype.add({
   extension = { tfbackend = "hcl", tofu = "terraform", tfstate = "json" },
   filename = { [".terraformrc"] = "hcl", ["terraform.rc"] = "hcl" },
   pattern = {
      [".*%.tftest%.hcl"] = "terraform",
      [".*%.tofutest%.hcl"] = "terraform",
      [".*%.tfstate%.backup"] = "json",
   },
})

autocmd("FileType", "terraform-vars", function()
   vim.bo.commentstring = "# %s"
end)

autocmd("BufReadPost", "*.tmpl", function()
   vim.bo.filetype = "gohtmltmpl"
end)

-- Don't continue comments on new lines; ftplugins re-add these, hence BufEnter.
-- Removes the "cro" sequence only, so markdown's "jcrqn" below stays intact.
autocmd("BufEnter", "*", function()
   vim.cmd("setlocal formatoptions-=cro")
end)

local indent = { json = 2, yaml = 2, vim = 2, nix = 2, markdown = 2, lua = 3 }
autocmd("FileType", vim.tbl_keys(indent), function(ev)
   local width = indent[ev.match]
   vim.bo.tabstop = width
   vim.bo.shiftwidth = width
   vim.bo.softtabstop = width
end)

autocmd("FileType", "markdown", function()
   vim.bo.formatoptions = "jcrqn"
end)

autocmd("FileType", "gitcommit", function()
   vim.opt_local.spell = true
end)

autocmd("FileType", { "qf", "man", "help", "fugitive" }, function(ev)
   vim.bo[ev.buf].buflisted = false
   vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
end)

-- Commands

vim.api.nvim_create_user_command("MD", "vertical botright terminal leaf -w %", {})
