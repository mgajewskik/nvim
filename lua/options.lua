local o = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

o.clipboard = "unnamedplus" -- Sync with system clipboard
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2 -- Hide * markup for bold and italic
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.cursorline = true -- Enable highlighting of the current line
o.expandtab = true -- Use spaces instead of tabs
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
o.ignorecase = true -- Ignore case
o.inccommand = "nosplit" -- preview incremental substitute
o.laststatus = 0
o.mouse = "a" -- Enable mouse mode
o.number = false -- Print line number
o.pumblend = 10 -- Popup blend
o.pumheight = 10 -- Maximum number of entries in a popup
o.relativenumber = false -- Relative line numbers
o.scrolloff = 4 -- Lines of context
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
o.shiftround = true -- Round indent
o.shiftwidth = 4 -- Size of an indent
o.shortmess:append({ W = true, I = true, c = true })
o.showmode = true -- Dont show mode since we have a statusline
o.sidescrolloff = 8 -- Columns of context
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.autoindent = true
o.spelllang = { "en" }
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.tabstop = 4 -- Number of spaces tabs count for
o.termguicolors = true -- True color support
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.autoread = true -- auto read file if changed outside of vim
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.wrap = true -- Disable line wrap
-- o.cmdheight = 2 -- cmdline height
o.showmode = false -- show current mode (insert, etc) under the cmdline

if vim.fn.has("nvim-0.9.0") == 1 then
   o.splitkeep = "screen"
   o.shortmess:append({ C = true })
end

o.list = false -- Show some invisible characters (tabs...
o.listchars = {
   -- tab = "→ ",
   tab = ">-",
   -- eol = "↲",
   -- nbsp = "␣",
   -- lead = " ",
   -- space = " ",
   -- trail = "␣",
   -- -- lead      = '␣'   ,
   -- -- space     = '␣'   ,
   -- -- trail     = '•'   ,
   -- extends = "⟩",
   -- precedes = "⟨",
}
o.showbreak = "↪ "

-- Make splits more visible
o.fillchars = {
   horiz = "━",
   horizup = "┻",
   horizdown = "┳",
   vert = "┃",
   vertleft = "┫",
   vertright = "┣",
   verthoriz = "╋",
}

o.formatoptions = "jcroqlnt" -- tcqj
-- -- c: auto-wrap comments using textwidth
-- -- r: auto-insert the current comment leader after hitting <Enter>
-- -- o: auto-insert the current comment leader after hitting 'o' or 'O'
-- -- q: allow formatting comments with 'gq'
-- -- n: recognize numbered lists
-- -- 1: don't break a line after a one-letter word
-- -- j: remove comment leader when it makes sense
-- -- this gets overwritten by ftplugins (:verb set fo)
-- -- we use autocmd to remove 'o' in '/lua/autocmd.lua'
-- -- borrowed from tjdevries
-- o.formatoptions = o.formatoptions
--    - "a" -- Auto formatting is BAD.
--    - "t" -- Don't auto format my code. I got linters for that.
--    + "c" -- In general, I like it when comments respect textwidth
--    + "q" -- Allow formatting comments w/ gq
--    - "o" -- O and o, don't continue comments
--    + "r" -- But do continue when pressing enter.
--    + "n" -- Indent past the formatlistpat, not underneath it.
--    + "j" -- Auto-remove comments if possible.
--    - "2" -- I'm not in gradeschool anymore
-- -- o.formatoptions = "jcroqln" -- tcqj

-- Globals

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

o.backup = false -- no backup file
o.writebackup = false -- do not backup file before write
o.swapfile = false -- no swap file
