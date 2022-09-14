local res, fzf_lua = pcall(require, "fzf-lua")
if not res then
    return
end

-- local fzf_bin = 'sk'

-- local function fzf_colors(binary)
-- 	binary = binary or fzf_bin
-- 	local colors = {
-- 		["fg"] = { "fg", "CursorLine" },
-- 		["bg"] = { "bg", "Normal" },
-- 		["hl"] = { "fg", "Comment" },
-- 		["fg+"] = { "fg", "ModeMsg" },
-- 		["bg+"] = { "bg", "CursorLine" },
-- 		["hl+"] = { "fg", "Statement" },
-- 		["info"] = { "fg", "PreProc" },
-- 		["prompt"] = { "fg", "Conditional" },
-- 		["pointer"] = { "fg", "Exception" },
-- 		["marker"] = { "fg", "Keyword" },
-- 		["spinner"] = { "fg", "Label" },
-- 		["header"] = { "fg", "Comment" },
-- 		["gutter"] = { "bg", "Normal" },
-- 	}
-- 	if binary == "sk" and vim.fn.executable(binary) == 1 then
-- 		colors["matched_bg"] = { "bg", "Normal" }
-- 		colors["current_match_bg"] = { "bg", "CursorLine" }
-- 	end
-- 	return colors
-- end

-- custom devicons setup file to be loaded when `multiprocess = true`
-- fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

fzf_lua.setup({
    -- lua_io             = true,            -- perf improvement, experimental
    global_resume = true,
    global_resume_query = true,
    winopts = {
        -- split            = "belowright new",
        -- split            = "aboveleft vnew",
        height = 0.85, -- window height
        width = 0.95, -- window width
        row = 0.35, -- window row position (0=top, 1=bottom)
        col = 0.55, -- window col position (0=left, 1=right)
        -- border = 'double',
        -- border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        -- border = { {'╭', 'IncSearch'}, {'─', 'IncSearch'}, {'╮', 'IncSearch'}, '│', '╯', '─', '╰', '│' },
        fullscreen = false, -- start fullscreen?
        hl = {
            normal = "Normal",
            border = "FloatBorder",
            -- builtin preview
            cursor = "Cursor",
            cursorline = "CursorLine",
            title = "ModeMsg",
            scrollbar_e = "Visual",
            scrollbar_f = "WildMenu",
        },
        preview = {
            -- default             = 'bat',
            -- default             = 'bat_native',
            border = "border",
            wrap = "nowrap",
            hidden = "nohidden",
            vertical = "down:45%",
            horizontal = "right:60%",
            layout = "flex",
            flip_columns = 120,
            title = true,
            scrollbar = "float",
            -- scrolloff           = '-1',
            -- scrollchars         = {'█', '░' },
        },
        on_create = function()
            -- print("on_create")
            -- vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:Normal")
        end,
    },
    -- winopts_fn = function() return { row = 1, height=0.5, width=0.5, border = "double" } end,
    keymap = {
        builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            -- Only valid with the 'builtin' previewer
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            -- Rotate preview clockwise/counter-clockwise
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
        },
        fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
        },
    },
    actions = {
        files = {
            -- ["default"]       = fzf_lua.actions.file_edit,
            ["default"] = fzf_lua.actions.file_edit_or_qf,
            ["ctrl-s"] = fzf_lua.actions.file_split,
            ["ctrl-v"] = fzf_lua.actions.file_vsplit,
            ["ctrl-t"] = fzf_lua.actions.file_tabedit,
            ["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
        },
        buffers = {
            ["default"] = fzf_lua.actions.buf_switch_or_edit,
            ["ctrl-s"] = fzf_lua.actions.buf_split,
            ["ctrl-v"] = fzf_lua.actions.buf_vsplit,
            ["ctrl-t"] = fzf_lua.actions.buf_tabedit,
        },
    },
    fzf_opts = {
        -- set to `false` to remove a flag
        ["--ansi"] = "",
        ["--prompt"] = "λ -> ",
        ["--info"] = "inline",
        ["--height"] = "100%",
        ["--layout"] = "reverse",
        ["--multi"] = "",
    },
    fzf_bin = fzf_bin,
    -- fzf_colors          = fzf_colors(),
    previewers = {
        bat = {
            theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
        },
        man = {
            cmd = "man -c %s | col -bx",
        },
        git_diff = {
            pager = "delta",
        },
        builtin = {
            syntax = true, -- preview syntax highlight?
            syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
            syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
        },
    },
    lines = { prompt = "Lines❯ " },
    blines = { prompt = "BLines❯ " },
    buffers = { prompt = "Buffers❯ " },
    files = {
        prompt = "Files❯ ",
        actions = {
            ["ctrl-l"] = fzf_lua.actions.arg_add,
            ["ctrl-y"] = function(selected)
                print(selected[1])
            end,
        },
        multiprocess = true,
        debug = false,
        cmd = "rg --files --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -g '!{**/.zinit/*,go/pkg/*,**/.npm/*,**/.rvm/*,**/.node-gyp/*,**/.git/*,**/.tox/*,**/venv/*,**/.venv/*,.pyenv/*,*.pyi,*.pyc,**/__pycache__/*,**/.pytest_cache/*,.cache/*,**/.terraform/*,**/.mypy_cache/*}' 2> /dev/null",
    },
    grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -g '!{**/.zinit/*,go/pkg/*,**/.npm/*,**/.rvm/*,**/.node-gyp/*,**/.git/*,**/.tox/*,**/venv/*,**/.venv/*,.pyenv/*,*.pyi,*.pyc,**/__pycache__/*,**/.pytest_cache/*,.cache/*,**/.terraform/*,**/.mypy_cache/*}' 2> /dev/null",
        -- 'true' enables file and git icons in 'live_grep'
        -- degrades performance in large datasets, YMMV
        experimental = true,
        multiprocess = true,
        debug = false,
        debug_cmd = false,
        -- fzf_cli_args      = '--keep-right',
    },
    git = {
        files = {
            prompt = "GitFiles❯ ",
            multiprocess = true,
            debug = false,
        },
        status = { prompt = "GitStatus❯ " },
        commits = { prompt = "Commits❯ " },
        -- bcommits          = { prompt = 'BCommits❯ ', },
        branches = { prompt = "Branches❯ " },
        bcommits = {
            prompt = "Tags❯ ",
            cmd = "git log --tags --decorate --simplify-by-decoration --oneline --color",
            preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
            actions = {
                -- ["default"] = fzf_lua.actions.git_switch,
                ["default"] = fzf_lua.actions.git_checkout,
            },
        },
        icons = {
            -- ["M"]    = { icon = "★", color = "red" },
            -- ["D"]    = { icon = "✗", color = "red" },
            -- ["A"]    = { icon = "+", color = "green" },
        },
    },
    args = {
        prompt = "Args❯ ",
        files_only = true,
    },
    oldfiles = {
        prompt = "History❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = false,
    },
    colorschemes = {
        prompt = "Colorschemes❯ ",
        live_preview = true,
        winopts = {
            win_height = 0.55,
            win_width = 0.30,
        },
        post_reset_cb = function()
            -- reset statusline highlights after
            -- a live_preview of the colorscheme
            -- require('feline').reset_highlights()
        end,
    },
    -- optional override of file extension icon colors
    -- available colors (terminal):
    --    clear, bold, black, red, green, yellow
    --    blue, magenta, cyan, grey, dark_grey, white
    file_icon_padding = "",
    file_icon_colors = {
        ["sh"] = "green",
    },
    -- uncomment to disable the previewer
    -- nvim = { marks = { previewer = false } },
    -- nvim = { marks = { previewer = { _ctor = false } } },
    -- helptags = { previewer = false },
    -- helptags = { previewer = { _ctor = false } },
    -- manpages = { previewer = false },
    -- manpages = { previewer = { _ctor = false } },
    -- uncomment to set dummy win split (top bar)
    -- "topleft"  : up
    -- "botright" : down
    -- helptags = { previewer = { split = "topleft" } },
    -- uncomment to use `man` command as native fzf previewer
    -- manpages = { previewer = { _ctor = require'fzf-lua.previewer'.fzf.man_pages } },
    -- tags = { previewer = 'bat_native' }
    -- tags = { previewer = false },
    -- tags = { previewer = { _ctor = false } },
})

local M = {}

function M.edit_neovim(opts)
    if not opts then
        opts = {}
    end
    opts.prompt = "< VimRC > "
    opts.cwd = "$HOME/.config/nvim"
    fzf_lua.files(opts)
end

function M.edit_sdu(opts)
    if not opts then
        opts = {}
    end
    opts.prompt = "~ sdu ~ "
    opts.cwd = "$HOME/sdu"
    fzf_lua.live_grep_glob(opts)
end

--function M.edit_zsh(opts)
--if not opts then opts = {} end
--opts.prompt = "~ zsh ~ "
--opts.cwd = "$HOME/.config/zsh"
--fzf_lua.files(opts)
--end

function M.root_files(opts)
    if not opts then
        opts = {}
    end
    opts.prompt = "~ home ~ "
    opts.cwd = "$HOME"
    fzf_lua.files(opts)
end

function M.obsidian_files(opts)
    if not opts then
        opts = {}
    end
    opts.prompt = "~ obsidian ~ "
    opts.cwd = "$HOME/Dropbox/obsidian"
    fzf_lua.files(opts)
end

--function M.installed_plugins(opts)
--if not opts then opts = {} end
--opts.prompt = 'Plugins❯ '
--opts.cwd = vim.fn.stdpath "data" .. "/site/pack/packer/"
--fzf_lua.files(opts)
--end

-- function M.git_status_tmuxZ(opts)
--   local function tmuxZ()
--     vim.cmd("!tmux resize-pane -Z")
--   end
--   opts = opts or {}
--   opts.fn_pre_win = function(_)
--     if not opts.__want_resume then
--       -- new fzf window, set tmux Z
--       -- add small delay or fzf
--       -- win gets wrong dimensions
--       tmuxZ()
--       vim.cmd("sleep! 20m")
--     end
--     opts.__want_resume = nil
--   end
--   opts.fn_post_fzf = function(_, s)
--     opts.__want_resume = s and (s[1] == 'left' or s[1] == 'right')
--     if not opts.__want_resume then
--       -- resume asked do not resize
--       -- signals fn_pre to do the same
--       tmuxZ()
--     end
--   end
--   fzf_lua.git_status(opts)
-- end

local _previous_cwd = nil

-- TODO how to add fuzzy writing of a directory here instead of hardcoded
function M.workdirs(opts)
    if not opts then
        opts = {}
    end

    -- workdirs.lua returns a table of workdirs
    local ok, dirs = pcall(require, "workdirs")
    if not ok then
        dirs = {}
    end

    local iconify = function(path, color, icon)
        icon = fzf_lua.utils.ansi_codes[color](icon)
        path = fzf_lua.path.relative(path, vim.fn.expand("$HOME"))
        return ("%s  %s"):format(icon, path)
    end

    local dedup = {}
    local entries = {}
    local add_entry = function(path, color, icon)
        if not path then
            return
        end
        path = vim.fn.expand(path)
        if not vim.loop.fs_stat(path) then
            return
        end
        if dedup[path] ~= nil then
            return
        end
        entries[#entries + 1] = iconify(path, color or "blue", icon or "")
        dedup[path] = true
    end

    add_entry(vim.loop.cwd(), "magenta", "")
    add_entry(_previous_cwd, "yellow")
    add_entry("$HOME/sdu/repos")
    add_entry("$HOME/tzif.io/infra")
    add_entry("$HOME/tzif.io")
    add_entry("$HOME/repos")
    add_entry("$HOME")
    add_entry("$HOME/.config")
    add_entry("$HOME/.config/nvim")
    add_entry("$HOME/Dropbox/obsidian")
    for _, path in ipairs(dirs) do
        add_entry(path)
    end

    local fzf_fn = function(cb)
        for _, entry in ipairs(entries) do
            cb(entry)
        end
        cb(nil)
    end

    opts.fzf_opts = {
        ["--no-multi"] = "",
        ["--prompt"] = "Workdirs❯ ",
        ["--preview-window"] = "hidden:right:0",
        ["--header-lines"] = "1",
    }

    fzf_lua.fzf_wrap(opts, fzf_fn, function(selected)
        if not selected then
            return
        end
        _previous_cwd = vim.loop.cwd()
        local newcwd = selected[1]:match("[^ ]*$")
        newcwd = fzf_lua.path.starts_with_separator(newcwd) and newcwd
            or fzf_lua.path.join({ vim.fn.expand("$HOME"), newcwd })
        require("utils").set_cwd(newcwd)
    end)()
end

local map_fzf = function(mode, key, f, options, buffer)
    local rhs = function()
        if not pcall(require, "fzf-lua") then
            require("packer").loader("fzf-lua")
        end
        require("config.fzf")[f](options or {})
    end

    local map_options = {
        noremap = true,
        silent = true,
        buffer = buffer,
    }

    require("utils").remap(mode, key, rhs, map_options)
end

-- local remap = require'utils'.remap
-- local default_options = {
--     noremap = true,
--     silent = true,
--     -- buffer = buffer,
--   }
--
-- remap("n", "<C-p>", "files", default_options)

local map = vim.keymap.set
local default_options = { silent = true }
--
-- map("n", "<C-p>", ":FzfLua files<CR>", default_options)
-- map("n", "<leader>`", ":FzfLua buffers<CR>", default_options)
map("n", "<leader>ss", ":FzfLua<CR>", default_options)
--
-- map_fzf('n', '<C-r>', "workdirs", {
--   winopts = {
--     height       = 0.40,
--     width        = 0.60,
--     row          = 0.40,
--   }})

-- mappings
--
map_fzf("n", "<leader>sf", "obsidian_files", {})

-- map_fzf('n', '<F1>', "help_tags")
map_fzf("n", "<C-p>", "files", {})
map_fzf("n", "<C-r>", "workdirs", {
    winopts = {
        height = 0.40,
        width = 0.60,
        row = 0.40,
    },
})
-- map_fzf('n', '<C-r>', "root_files", {})

map_fzf("n", "<leader>f", "git_files", {})
-- map_fzf('n', '<leader>wf', "workdirs", {
--   winopts = {
--     height       = 0.40,
--     width        = 0.60,
--     row          = 0.40,
--   }})
map_fzf("n", "<leader>rf", "root_files", {})
map_fzf("n", "<leader>`", "buffers")
--map_fzf('n', '<leader>fr', "grep", {})
--map_fzf('n', '<leader>fl', "live_grep_glob", {})
-- map_fzf("n", "<leader>\\\\", "live_grep_glob", {})
map_fzf("n", "\\\\", "live_grep_glob", {})
--map_fzf('n', '<leader>fR', "live_grep_glob", { repeat_last_search = true })
--map_fzf('n', '<leader>ff', "resume")
-- map_fzf('n', '<leader>ff', "grep", { repeat_last_search = true} )
map_fzf("n", "<leader>ws", "grep_cword")
--map_fzf('n', '<leader>fW', "grep_cWORD")
--map_fzf('n', '<leader>fv', "grep_visual")
map_fzf("v", "<leader>ws", "grep_visual")
map_fzf("n", "//", "blines")
--map_fzf('n', '<leader>fB', "lgrep_curbuf", { prompt = 'Buffer❯ ' })
--map_fzf('n', '<leader>fh', "oldfiles", { cwd = "~" })
--map_fzf('n', '<leader>fH', "oldfiles", function()
--return {
--cwd = vim.loop.cwd(),
--show_cwd_header = true,
--cwd_only = true,
--}
--end)
map_fzf("n", "<leader>sq", "quickfix")
map_fzf("n", "<leader>sQ", "loclist")
--map_fzf('n', '<leader>fo', "colorschemes")
map_fzf("n", "<leader>sM", "man_pages")

-- Nvim & Dots
map_fzf("n", "<leader>sn", "edit_neovim")
-- map_fzf('n', '<leader>sf', "edit_sdu")
-- map_fzf('n', '<leader>ez', "edit_zsh")
--map_fzf('n', '<leader>ep', "installed_plugins")

-- LSP
map_fzf("n", "gr", "lsp_references")
-- map_fzf('n', '<leader>ld', "lsp_definitions", { jump_to_single_result = false })
-- map_fzf('n', '<leader>lD', "lsp_declarations")
-- map_fzf('n', '<leader>ly', "lsp_typedefs")
-- map_fzf('n', '<leader>lm', "lsp_implementations")
-- map_fzf('n', '<leader>ls', "lsp_document_symbols")
-- map_fzf('n', '<leader>lS', "lsp_workspace_symbols")
map_fzf("n", "<leader>sa", "lsp_code_actions", {
    winopts = {
        win_height = 0.30,
        win_width = 0.70,
        win_row = 0.40,
    },
})
map_fzf("n", "<leader>sd", "lsp_document_diagnostics", { file_icons = false })
map_fzf("n", "<leader>sD", "lsp_workspace_diagnostics", { file_icons = false })

-- Git
map_fzf("n", "<leader>sb", "git_branches")
map_fzf("n", "<leader>sc", "git_commits")
map_fzf("n", "<leader>sC", "git_bcommits")
-- map_fzf("n", "<leader>st", "git_tags")

-- map_fzf('n', '<leader>ss', "git_status", {
--   preview_vertical = "down:70%",
--   preview_horizontal = "right:70%",
-- })
-- Full screen git status
--map_fzf('n', '<leader>fS', "git_status_tmuxZ", {
--winopts = {
--fullscreen = true,
--preview = {
--vertical = "down:70%",
--horizontal = "right:70%",
--}
--}
--})

-- Fzf-lua methods
-- map_fzf("n", "<leader>f?", "builtin")
map_fzf("n", "<leader>sm", "marks")
map_fzf("n", "<leader>sx", "commands")
map_fzf("n", "<leader>s:", "command_history")
map_fzf("n", "<leader>s/", "search_history")
map_fzf("n", '<leader>s"', "registers")
-- map_fzf('n', '<leader>s"', "register_ui_select")
map_fzf("n", "<leader>sk", "keymaps")
-- map_fzf('n', '<leader>fz', "spell_suggest", {
--   winopts = {
--     win_height       = 0.60,
--     win_width        = 0.50,
--     win_row          = 0.40,
--   }})
-- map_fzf('n', '<leader>st', "tags")
-- map_fzf('n', '<leader>st', "btags")

return setmetatable({}, {
    __index = function(_, k)
        if M[k] then
            return M[k]
        else
            return require("fzf-lua")[k]
        end
    end,
})
