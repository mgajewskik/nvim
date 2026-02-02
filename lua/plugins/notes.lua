return {
   -- {
   --    "renerocksai/telekasten.nvim",
   --    dependencies = {
   --       "renerocksai/calendar-vim",
   --       "nvim-telescope/telescope.nvim",
   --    },
   --    lazy = false,
   --    keys = {
   --       { "<leader>zf", "<CMD>Telekasten find_notes<CR>", { noremap = true } },
   --       { "<leader>zs", "<CMD>Telekasten search_notes<CR>", { noremap = true } },
   --       { "<leader>zd", "<CMD>Telekasten find_daily_notes<CR>", { noremap = true } },
   --       { "<leader>zw", "<CMD>Telekasten find_weekly_notes<CR>", { noremap = true } },
   --       { "<leader>zg", "<CMD>Telekasten find_friends<CR>", { noremap = true } },
   --       { "<leader>zt", "<CMD>Telekasten show_tags<CR>", { noremap = true } },
   --       { "<leader>zb", "<CMD>Telekasten show_backlinks<CR>", { noremap = true } },
   --       { "<leader>zc", "<CMD>Telekasten show_calendar<CR>", { noremap = true } },
   --       { "<leader>znn", "<CMD>Telekasten new_note<CR>", { noremap = true } },
   --       { "<leader>znd", "<CMD>Telekasten goto_today<CR>", { noremap = true } },
   --       { "<leader>znw", "<CMD>Telekasten goto_thisweek<CR>", { noremap = true } },
   --       { "<leader>zz", "<CMD>Telekasten follow_link<CR>", { noremap = true } },
   --       { "<leader>zl", "<CMD>Telekasten insert_link<CR>", { noremap = true } },
   --       { "<leader>zy", "<CMD>Telekasten yank_notelink<CR>", { noremap = true } },
   --       { "<leader>zm", "<CMD>Telekasten browse_media<CR>", { noremap = true } },
   --       { "<leader>zi", "<CMD>Telekasten preview_img<CR>", { noremap = true } },
   --       { "<leader>za", "<CMD>Telekasten toggle_todo<CR>", { noremap = true } },
   --       { "<leader>zr", "<CMD>Telekasten rename_note<CR>", { noremap = true } },
   --       { "<leader>z?", "<CMD>Telekasten panel<CR>", { noremap = true } },
   --    },
   --    init = function()
   --       vim.cmd([[hi tklink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline]])
   --       vim.cmd([[hi tkBrackets ctermfg=gray guifg=gray]])
   --       vim.cmd([[hi tkHighlight ctermbg=214 ctermfg=124 cterm=bold guibg=#fabd2f guifg=#9d0006 gui=bold]])
   --
   --       -- Calendar color change
   --       vim.cmd([[hi link CalNavi CalRuler]])
   --       vim.cmd([[hi tkTagSep ctermfg=gray guifg=gray]])
   --       vim.cmd([[hi tkTag ctermfg=175 guifg=#d3869B]])
   --    end,
   --    config = function()
   --       -- TODO cleanup this mess
   --       local home = vim.fn.expand("$NOTES_PATH")
   --
   --       require("telekasten").setup({
   --          home = home,
   --          install_syntax = true,
   --          -- if true, telekasten will be enabled when opening a note within the configured home
   --          take_over_my_home = true,
   --          -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
   --          --                               and thus the telekasten syntax will not be loaded either
   --          auto_set_filetype = false,
   --          -- dir names for special notes (absolute path or subdir name)
   --          dailies = home .. "/" .. "journal/daily",
   --          weeklies = home .. "/" .. "journal/weekly",
   --          templates = home .. "/" .. "templates",
   --          -- image (sub)dir for pasting
   --          -- dir name (absolute path or subdir name)
   --          -- or nil if pasted images shouldn't go into a special subdir
   --          image_subdir = "media",
   --          -- markdown file extension
   --          extension = ".md",
   --          -- following a link to a non-existing note will create it
   --          follow_creates_nonexisting = true,
   --          dailies_create_nonexisting = true,
   --          weeklies_create_nonexisting = true,
   --          -- template for new notes (new_note, follow_link)
   --          -- set to `nil` or do not specify if you do not want a template
   --          template_new_note = home .. "/" .. "templates/note.md",
   --          -- template for newly created daily notes (goto_today)
   --          -- set to `nil` or do not specify if you do not want a template
   --          template_new_daily = home .. "/" .. "templates/daily.md",
   --          -- template for newly created weekly notes (goto_thisweek)
   --          -- set to `nil` or do not specify if you do not want a template
   --          template_new_weekly = home .. "/" .. "templates/weekly.md",
   --          -- image link style
   --          -- wiki:     ![[image name]]
   --          -- markdown: ![](image_subdir/xxxxx.png)
   --          image_link_style = "wiki",
   --          -- integrate with calendar-vim
   --          plug_into_calendar = true,
   --          calendar_opts = {
   --             -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
   --             weeknm = 1,
   --             -- use monday as first day of week: 1 .. true, 0 .. false
   --             calendar_monday = 1,
   --             -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
   --             calendar_mark = "left-fit",
   --          },
   --          -- telescope actions behavior
   --          close_after_yanking = false,
   --          insert_after_inserting = true,
   --          -- tag notation: '#tag', ':tag:', 'yaml-bare'
   --          tag_notation = "#tag",
   --          -- command palette theme: dropdown (window) or ivy (bottom panel)
   --          command_palette_theme = "dropdown",
   --          -- tag list theme:
   --          -- get_cursor: small tag list at cursor; ivy and dropdown like above
   --          show_tags_theme = "dropdown",
   --          -- when linking to a note in subdir/, create a [[subdir/title]] link
   --          -- instead of a [[title only]] link
   --          subdirs_in_links = false,
   --          -- template_handling
   --          -- What to do when creating a new note via `new_note()` or `follow_link()`
   --          -- to a non-existing note
   --          -- - prefer_new_note: use `new_note` template
   --          -- - smart: if day or week is detected in title, use daily / weekly templates (default)
   --          -- - always_ask: always ask before creating a note
   --          template_handling = "smart",
   --          -- path handling:
   --          --   this applies to:
   --          --     - new_note()
   --          --     - new_templated_note()
   --          --     - follow_link() to non-existing note
   --          --
   --          --   it does NOT apply to:
   --          --     - goto_today()
   --          --     - goto_thisweek()
   --          --
   --          --   Valid options:
   --          --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
   --          --              all other ones in home, except for notes/with/subdirs/in/title.
   --          --              (default)
   --          --
   --          --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
   --          --                    except for notes with subdirs/in/title.
   --          --
   --          --     - same_as_current: put all new notes in the dir of the current note if
   --          --                        present or else in home
   --          --                        except for notes/with/subdirs/in/title.
   --          new_note_location = "smart",
   --          -- should all links be updated when a file is renamed
   --          rename_update_links = true,
   --          -- how to preview media files
   --          -- "telescope-media-files" if you have telescope-media-files.nvim installed
   --          -- "catimg-previewer" if you have catimg installed
   --          media_previewer = "telescope-media-files",
   --       })
   --    end,
   -- },
   {
      "obsidian-nvim/obsidian.nvim",
      version = "*",
      lazy = false,
      ft = "markdown",
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      keys = {
         { "<leader>zs", "<CMD>Obsidian search<CR>", { noremap = true } },
         { "<leader>zf", "<CMD>Obsidian quick_switch<CR>", { noremap = true } },
         { "<leader>zl", "<CMD>Obsidian links<CR>", { noremap = true } },
         { "<leader>zh", "<CMD>Obsidian backlinks<CR>", { noremap = true } },
         { "<leader>zd", "<CMD>ObsidianDailiesFzf -2 1<CR>", { noremap = true, desc = "Daily notes picker" } },
         { "<leader>znd", "<CMD>Obsidian today<CR>", { noremap = true } },
         { "<leader>znn", "<CMD>Obsidian new<CR>", { noremap = true, desc = "New note" } },
         {
            "<leader>znh",
            function()
               local vault = vim.fn.expand("$NOTES_PATH")
               local buf_path = vim.fn.expand("%:p:h")

               if not buf_path:find(vault, 1, true) then
                  vim.notify("Not in obsidian vault", vim.log.levels.ERROR)
                  return
               end

               local rel_path = buf_path:sub(#vault + 2) .. "/"
               if rel_path == "/" then
                  rel_path = ""
               end

               vim.ui.input({ prompt = "Note title: ", default = rel_path }, function(input)
                  if input and input ~= "" then
                     vim.cmd("Obsidian new " .. input)
                  end
               end)
            end,
            desc = "New note here",
         },
         { "<leader>znt", "<CMD>Obsidian new_from_template<CR>", { noremap = true } },
         { "<leader>zz", "<CMD>Obsidian follow_link vsplit<CR>", { noremap = true } },
         { "<leader>zt", "<CMD>Obsidian tags<CR>", { noremap = true } },
         { "<leader>zr", "<CMD>Obsidian rename<CR>", { noremap = true } },
         { "<leader>za", "<CMD>Obsidian toggle_checkbox<CR>", { noremap = true } },
      },
      opts = {
         legacy_commands = false,
         workspaces = {
            {
               name = "notes",
               path = vim.fn.expand("$NOTES_PATH"),
            },
         },
         picker = {
            name = "fzf-lua",
            note_mappings = {
               new = "<C-x>",
               insert_link = "<C-l>",
            },
            tag_mappings = {
               tag_note = "<C-x>",
               insert_tag = "<C-l>",
            },
         },
         search = {
            sort_by = "modified",
            sort_reversed = true,
            max_lines = 3000,
         },
         completion = {
            blink = true,
            min_chars = 2,
         },
         new_notes_location = "current_dir",
         notes_subdir = "inbox",
         daily_notes = {
            folder = vim.fn.expand("$NOTES_DAILY_PATH"),
            date_format = "%Y-%m-%d",
            default_tags = { "daily" },
            template = "daily.md",
         },
         templates = {
            folder = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            substitutions = {
               yesterday = function()
                  return os.date("%Y-%m-%d", os.time() - 86400)
               end,
               tomorrow = function()
                  return os.date("%Y-%m-%d", os.time() + 86400)
               end,
            },
         },
         attachments = {
            folder = "media",
         },
         ui = {
            enable = true,
         },
         statusline = {
            enabled = false,
         },
         footer = {
            enabled = false,
         },
         checkbox = {
            enabled = true,
            create_new = true,
            order = { " ", "x" },
         },
         frontmatter = {
            enabled = false,
         },
         note_id_func = function(title)
            if not title or title == "" then
               return os.date("%Y%m%d%H%M")
            end
            return title
         end,
         link = {
            wiki = function(opts)
               local header_or_block = ""
               if opts.anchor then
                  header_or_block = opts.anchor.anchor
               elseif opts.block then
                  header_or_block = string.format("#%s", opts.block.id)
               end
               local filename = vim.fs.basename(tostring(opts.path))
               return string.format("[[%s%s]]", filename, header_or_block)
            end,
         },
         note_path_func = function(spec)
            local path
            if spec.id:match("^%d%d%d%d%d%d%d%d%d%d%d%d$") then
               path = spec.dir:parent() / "inbox" / tostring(spec.id)
            else
               path = spec.dir / tostring(spec.id)
            end
            return path:with_suffix(".md")
         end,
      },
      config = function(_, opts)
         local daily_folder = vim.fn.expand("$NOTES_PATH") .. "/" .. opts.daily_notes.folder

         vim.api.nvim_create_user_command("ObsidianDailiesFzf", function(cmd_opts)
            local fzf = require("fzf-lua")
            local builtin = require("fzf-lua.previewer.builtin")

            local offset_start, offset_end = -5, 1
            if cmd_opts.fargs and #cmd_opts.fargs >= 2 then
               offset_start = tonumber(cmd_opts.fargs[1]) or -5
               offset_end = tonumber(cmd_opts.fargs[2]) or 1
               if offset_start > offset_end then
                  offset_start, offset_end = offset_end, offset_start
               end
            elseif cmd_opts.fargs and #cmd_opts.fargs == 1 then
               local n = tonumber(cmd_opts.fargs[1]) or 0
               if n >= 0 then
                  offset_end = n
               else
                  offset_start = n
               end
            end

            local entries = {}
            local offset_map = {}

            for offset = offset_end, offset_start, -1 do
               local datetime = os.time() + (offset * 3600 * 24)
               local date_str = os.date("%Y-%m-%d", datetime)
               local filename = daily_folder .. "/" .. date_str .. ".md"
               local display = os.date("%A %B %-d, %Y", datetime)

               if offset == 0 then
                  display = display .. " @today"
               elseif offset == -1 then
                  display = display .. " @yesterday"
               elseif offset == 1 then
                  display = display .. " @tomorrow"
               end

               if vim.fn.filereadable(filename) == 0 then
                  display = display .. " ➡️ create"
               end

               entries[#entries + 1] = filename .. "\t" .. display
               offset_map[filename] = offset
            end

            local DailyPreviewer = builtin.buffer_or_file:extend()

            function DailyPreviewer:new(o, preview_opts, fzf_win)
               DailyPreviewer.super.new(self, o, preview_opts, fzf_win)
               setmetatable(self, DailyPreviewer)
               return self
            end

            function DailyPreviewer:parse_entry(entry_str)
               local path = entry_str:match("^([^\t]+)")
               return {
                  path = path,
                  line = 1,
                  col = 1,
               }
            end

            fzf.fzf_exec(entries, {
               prompt = "Dailies ❯ ",
               previewer = DailyPreviewer,
               fzf_opts = { ["--delimiter"] = "\t", ["--with-nth"] = "2" },
               actions = {
                  ["default"] = function(selected)
                     if selected[1] then
                        local filename = selected[1]:match("^([^\t]+)")
                        local offset = offset_map[filename]
                        vim.cmd("Obsidian today " .. offset)
                     end
                  end,
                  ["ctrl-v"] = function(selected)
                     if selected[1] then
                        local filename = selected[1]:match("^([^\t]+)")
                        local offset = offset_map[filename]
                        vim.cmd("vsplit | Obsidian today " .. offset)
                     end
                  end,
                  ["ctrl-s"] = function(selected)
                     if selected[1] then
                        local filename = selected[1]:match("^([^\t]+)")
                        local offset = offset_map[filename]
                        vim.cmd("split | Obsidian today " .. offset)
                     end
                  end,
                  ["ctrl-t"] = function(selected)
                     if selected[1] then
                        local filename = selected[1]:match("^([^\t]+)")
                        local offset = offset_map[filename]
                        vim.cmd("tabedit | Obsidian today " .. offset)
                     end
                  end,
               },
            })
         end, { nargs = "*", desc = "Pick daily notes with fzf-lua (preview + splits)" })

         require("obsidian").setup(opts)
      end,
   },
}
