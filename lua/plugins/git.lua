return {
	{
		"tpope/vim-fugitive",
		lazy = true,
		keys = {
			{ "<leader>gs", "<Esc>:Git<CR>", { noremap = true } },
			{ "<leader>gB", "<Esc>:Git blame<CR>", { noremap = true } },
			{ "<leader>gc", "<Esc>:Git commit<CR>", { noremap = true } },
			{ "<leader>gv", "<Esc>:Gvdiffsplit!<CR>", { noremap = true } },
			{ "<leader>gl", "<Esc>:Git log --graph --abbrev-commit --decorate<CR>", { noremap = true } },
			{ "<leader>sr", "<Esc>:Git rebase -i HEAD~10<CR>", { noremap = true } },
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
		cmd = "DiffviewOpen",
		keys = {
			{ "<leader>gdh", ":DiffviewFileHistory<CR>", { noremap = true } },
			{ "<leader>gdd", ":DiffviewOpen origin/master", { noremap = true } },
			{ "<leader>gds", ":DiffviewOpen --staged", { noremap = true } },
		},
		config = true,
	},
	{
		"TimUntersberger/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = true,
		cmd = "Neogit",
		keys = {
			{ "<leader>sg", ":Neogit<CR>", { noremap = true, silent = true } },
		},
		config = true,
		-- Keybinding	Function
		-- Tab	Toggle diff
		-- 1, 2, 3, 4	Set a foldlevel
		-- $	Command history
		-- b	Branch popup
		-- s	Stage (also supports staging selection/hunk)
		-- S	Stage unstaged changes
		-- <C-s>	Stage Everything
		-- u	Unstage (also supports staging selection/hunk)
		-- U	Unstage staged changes
		-- c	Open commit popup
		-- r	Open rebase popup
		-- L	Open log popup
		-- p	Open pull popup
		-- P	Open push popup
		-- Z	Open stash popup
		-- ?	Open help popup
		-- x	Discard changes (also supports discarding hunks)
		-- <enter>	Go to file
		-- <C-r>	Refresh Buffer
		-- With diffview integration enabled
		--
		-- Keybinding	Function
		-- d	Open diffview.nvim at hovered file
		-- D (TODO)	Open diff popup
	},
}
