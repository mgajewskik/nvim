local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
	fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("HighlightYankedText", function(g)
	-- highlight yanked text and copy to system clipboard
	-- TextYankPost is also called on deletion, limit to
	-- yanks via v:operator
	aucmd("TextYankPost", {
		group = g,
		pattern = "*",
		command = "if has('clipboard') && v:operator=='y' && len(@0)>0 | "
			.. "let @+=@0 | endif | "
			.. "lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}",
	})
end)

-- auto-delete fugitive buffers
augroup("Fugitive", function(g)
	aucmd("BufReadPost,", {
		group = g,
		pattern = "fugitive://*",
		command = "set bufhidden=delete",
	})
end)

augroup("NewlineNoAutoComments", function(g)
	aucmd("BufEnter", {
		group = g,
		pattern = "*",
		command = "setlocal formatoptions-=o",
	})
end)

-- vim.api.nvim_create_augroup("Markdown", {
-- 	{ "BufRead,BufNewFile", "*.md", "setlocal textwidth=80" },
-- })
--
-- vim.api.nvim_create_augroup("GitCommit", {
-- 	{ "Filetype", "gitcommit", "setlocal spell textwidth=72" },
-- })

--- Remove all trailing whitespace on save
augroup("TrimWhiteSpaceGrp", function(g)
	aucmd("BufWritePre", {
		group = g,
		pattern = "*",
		command = [[:%s/\s\+$//e]],
	})
end)

-- -- update statusline highlights
-- augroup('StatusLineColorschemeUpdate', function(g)
--   aucmd("ColorScheme", {
--     group = g,
--     pattern = '*',
--     command = "lua require'plugins.statusline'.setup()",
--   })
-- end)
--
-- -- disable mini.indentscope for certain filetype|buftype
-- augroup('MiniIndentscopeDisable', function(g)
--   aucmd("BufEnter", {
--     group = g,
--     pattern = '*',
--     command = "if index(['fzf', 'help'], &ft) >= 0 "
--       .. "|| index(['nofile', 'terminal'], &bt) >= 0 "
--       .. "| let b:miniindentscope_disable=v:true | endif"
--   })
-- end)
--
--
-- augroup('TermOptions', function(g)
--   aucmd("TermOpen",
--   {
--     group = g,
--     pattern = '*',
--     command = 'setlocal listchars= nonumber norelativenumber'
--   })
-- end)
--
-- augroup('ResizeWindows', function(g)
--   aucmd("VimResized",
--   {
--     group = g,
--     pattern = '*',
--     command = 'tabdo wincmd ='
--   })
-- end)
--
-- augroup('ToggleColorcolumn', function(g)
--   aucmd("VimResized,WinEnter,BufWinEnter", {
--     group = g,
--     pattern = '*',
--     command = 'lua require"utils".toggle_colorcolumn()',
--   })
-- end)
--
-- augroup('ToggleSearchHL', function(g)
--   aucmd("InsertEnter",
--   {
--     group = g,
--     pattern = '*',
--     command = ':nohl | redraw'
--   })
-- end)
--
-- augroup('ActiveWinCursorLine', function(g)
--   -- Highlight current line only on focused window
--   aucmd("WinEnter,BufEnter,InsertLeave", {
--     group = g,
--     pattern = '*',
--     command = 'if ! &cursorline && ! &pvw | setlocal cursorline | endif'
--   })
--   aucmd("WinLeave,BufLeave,InsertEnter", {
--     group = g,
--     pattern = '*',
--     command = 'if &cursorline && ! &pvw | setlocal nocursorline | endif'
--   })
-- end)
--
-- augroup('PackerCompile', function(g)
--   aucmd("BufWritePost", {
--     group = g,
--     pattern = 'pluginList.lua',
--     command = 'lua require("plugins").compile()',
--   })
-- end)
--
--
-- augroup('Solidity', function(g)
--   aucmd("BufRead,BufNewFile", {
--     group = g,
--     pattern = '*.sol',
--     command = 'set filetype=solidity'
--   })
-- end)
--
-- -- Display help|man in vertical splits and map 'q' to quit
-- augroup('Help', function(g)
--   local function open_vert()
--     -- do nothing for floating windows or if this is
--     -- the fzf-lua minimized help window (height=1)
--     local cfg = vim.api.nvim_win_get_config(0)
--     if cfg and (cfg.external or cfg.relative and #cfg.relative>0)
--       or vim.api.nvim_win_get_height(0) == 1 then
--       return
--     end
--     -- do not run if Diffview is open
--     if vim.g.diffview_nvim_loaded and
--       require'diffview.lib'.get_current_view() then
--       return
--     end
--     local width = math.floor(vim.o.columns*0.75)
--     vim.cmd("wincmd L")
--     vim.cmd("vertical resize " .. width)
--     vim.keymap.set('n', 'q', '<CMD>q<CR>', { buffer = true })
--   end
--   aucmd("FileType", {
--     group = g,
--     pattern = 'help,man',
--     callback = open_vert,
--   })
--   -- we also need this auto command or help
--   -- still opens in a split on subsequent opens
--   aucmd("BufEnter", {
--     group = g,
--     pattern = '*.txt',
--     callback = function()
--       if vim.bo.buftype == 'help' then
--         open_vert()
--       end
--     end
--   })
--   aucmd("BufHidden", {
--     group = g,
--     pattern = 'man://*',
--     callback = function()
--       if vim.bo.filetype == 'man' then
--         local bufnr = vim.api.nvim_get_current_buf()
--         vim.defer_fn(function()
--           if vim.api.nvim_buf_is_valid(bufnr) then
--             vim.api.nvim_buf_delete(bufnr, {force=true})
--           end
--         end, 0)
--       end
--     end
--   })
-- end)

-- OLD
-- local au = require('au')
--
-- au.group('HighlightYankedText', function(g)
--   g.TextYankPost = {
--     '*',
--     function()
--       vim.highlight.on_yank{higroup='IncSearch', timeout=2000}
--     end
--   }
-- end)
--
-- au.group('NewlineNoAutoComments', function(g)
--   g.BufEnter = { '*', "setlocal formatoptions-=o" }
-- end)
--
-- au.group('TermOptions', function(g)
--     -- conflicts with neoterm
--     -- g.TermOpen = { '*', 'startinsert' },
--     g.TermOpen = { '*', 'setlocal listchars= nonumber norelativenumber' }
-- end)
--
-- au.group('ResizeWindows', function(g)
--     g.VimResized = { '*', 'tabdo wincmd =' }
-- end)
--
-- au.group('ToggleColorcolumn', {
--   {
--     'VimResized,WinEnter,BufWinEnter', '*',
--     function()
--       require'utils'.toggle_colorcolumn()
--     end,
--   }
-- })
--
-- au.group('ToggleSearchHL', function(g)
--   g.InsertEnter = { '*', ':nohl | redraw' }
-- end)
--
-- au.group('ActiveWinCursorLine', {
--   -- Highlight current line only on focused window
--   {'WinEnter,BufEnter,InsertLeave', '*', 'if ! &cursorline && ! &pvw | setlocal cursorline | endif'};
--   {'WinLeave,BufLeave,InsertEnter', '*', 'if &cursorline && ! &pvw | setlocal nocursorline | endif'};
-- })
--
-- au.group('PackerCompile', function(g)
--   g.BufWritePost = {
--     'packer_init.lua',
--     function()
--       require('plugins').compile()
--     end
--   }
-- end)
--
-- au.group('Solidity', {
--   { 'BufRead,BufNewFile', '*.sol', 'set filetype=solidity' }
-- })
--
--
-- -- Display help|man in vertical splits
-- au.group('Help', function(g)
--   g.FileType = { 'help,man',
--     function()
--       -- do nothing for floating windows
--       local cfg = vim.api.nvim_win_get_config(0)
--       if cfg and (cfg.external or cfg.relative and #cfg.relative>0) then
--         return
--       end
--       -- do not run if Diffview is open
--       if vim.g.diffview_nvim_loaded and
--         require'diffview.lib'.get_current_view() then
--         return
--       end
--       -- local var = vim.bo.filetype .. "_init"
--       -- local ok, is_init = pcall(vim.api.nvim_buf_get_var, 0, var)
--       -- if ok and is_init == true then return end
--       -- vim.api.nvim_buf_set_var(0, var, true)
--       local width = math.floor(vim.o.columns*0.75)
--       vim.cmd("wincmd L")
--       vim.cmd("vertical resize " .. width)
--     end
--   }
--   -- TODO:
--   -- Why does setting this event ft to 'man' not work?
--   -- but at the same time '*' works and shows 'man' for ft?
--   g.BufHidden = { '*',
--     function()
--       if vim.bo.filetype == 'man' then
--         local bufnr = vim.api.nvim_get_current_buf()
--         vim.defer_fn(function()
--           if vim.api.nvim_buf_is_valid(bufnr) then
--             vim.api.nvim_buf_delete(bufnr, {force=true})
--           end
--         end, 0)
--       end
--     end }
-- end)
--
--
--
--
--
-- NEW FUNCTIONS
--
-- local api = vim.api
--
--
-- -- don't auto comment new line
-- api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
--
-- -- Close nvim if NvimTree is only running buffer
-- api.nvim_create_autocmd(
--   "BufEnter",
--   { command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]] }
-- )
--
-- -- Highlight on yank
-- local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
-- api.nvim_create_autocmd("TextYankPost", {
--   command = "silent! lua vim.highlight.on_yank()",
--   group = yankGrp,
-- })
-- -- go to last loc when opening a buffer
-- api.nvim_create_autocmd(
--   "BufReadPost",
--   { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
-- )
-- -- windows to close with "q"
-- api.nvim_create_autocmd("FileType", {
--   pattern = { "help", "startuptime", "qf", "lspinfo", "fugitive", "null-ls-info" },
--   command = [[nnoremap <buffer><silent> q :close<CR>]],
-- })
-- api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
--
-- -- disable list option in certain filetypes
-- api.nvim_create_autocmd("FileType", { pattern = { "NeoGitStatus" }, command = [[setlocal list!]] })
--
-- -- show cursor line only in active window
-- local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
-- api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
--   pattern = "*",
--   command = "set cursorline",
--   group = cursorGrp,
-- })
-- api.nvim_create_autocmd(
--   { "InsertEnter", "WinLeave" },
--   { pattern = "*", command = "set nocursorline", group = cursorGrp }
-- )
--
-- -- Enable spell checking for certain file types
-- api.nvim_create_autocmd(
--   { "BufRead", "BufNewFile" },
--   { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
-- )
--
-- -- enable PackerSync on plugins.lua save
-- local packer_auto_sync = false
--
-- if packer_auto_sync then
--   -- source plugins.lua and run PackerSync on save
--   local sync_packer = function()
--     vim.cmd("runtime lua/plugins.lua")
--     require("packer").sync()
--   end
--   api.nvim_create_autocmd({ "BufWritePost" }, {
--     pattern = { "plugins.lua" },
--     callback = sync_packer,
--   })
-- end
