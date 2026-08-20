local function create_obsidian_note(opts)
   vim.ui.input({ prompt = opts.prompt or "Note title: " }, function(input)
      if input == nil then
         return
      elseif input == "" then
         input = nil
      end

      local note = require("obsidian.note").create({
         id = input,
         dir = opts.dir,
         template = Obsidian.opts.note.template,
      })
      note:write({})
      note:open({ sync = true })
   end)
end

local function create_obsidian_note_in_current_dir()
   local buf_path = vim.api.nvim_buf_get_name(0)
   local Path = require("obsidian.path")

   if buf_path == "" then
      vim.notify("Current buffer has no file path", vim.log.levels.ERROR)
      return
   end

   local dir = Path.new(vim.fs.dirname(buf_path)):resolve()
   local in_workspace = false
   for _, workspace in ipairs(Obsidian.workspaces) do
      if workspace.root == dir or workspace.root:is_parent_of(dir) then
         in_workspace = true
         break
      end
   end

   if not in_workspace then
      vim.notify("Not in obsidian vault", vim.log.levels.ERROR)
      return
   end

   create_obsidian_note({ dir = dir })
end

local function open_current_obsidian_weekly_note()
   local Note = require("obsidian.note")
   local Path = require("obsidian.path")
   local util = require("obsidian.util")

   local weekly_opts = vim.tbl_extend("force", {
      folder = "area/journal/weekly",
      date_format = "GGGG-[W]WW",
      template = "weekly.md",
   }, Obsidian.opts.weekly_notes or {})

   local week_id = tostring(util.format_date(os.time(), weekly_opts.date_format))
   local dir = Path.new(weekly_opts.folder)
   if not dir:is_absolute() then
      dir = Obsidian.dir / weekly_opts.folder
   end

   local path = dir / (week_id .. ".md")
   local note

   if path:is_file() then
      note = Note.from_file(path)
   else
      note = Note.new(week_id, {}, weekly_opts.default_tags or {}, path, week_id)

      local template_path
      local template_opts = Obsidian.opts.templates or {}
      if weekly_opts.template ~= nil and template_opts.enabled ~= false and template_opts.folder ~= nil then
         local templates_dir = Obsidian.dir / template_opts.folder
         template_path = templates_dir / weekly_opts.template
         if not template_path:is_file() and not vim.endswith(tostring(template_path), ".md") then
            template_path = Path.new(tostring(template_path) .. ".md")
         end
      end

      if template_path ~= nil and template_path:is_file() then
         note = note:write({ template = template_path })
      else
         assert(path:parent()):mkdir({ parents = true })
         util.write_file(tostring(path), "# " .. week_id .. "\n")
      end
   end

   note:open({ sync = true })
end

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
      keys = {
         { "<leader>zs", "<CMD>Obsidian search<CR>", { noremap = true } },
         { "<leader>zf", "<CMD>Obsidian quick_switch<CR>", { noremap = true } },
         { "<leader>zl", "<CMD>Obsidian links<CR>", { noremap = true } },
         { "<leader>zh", "<CMD>Obsidian backlinks<CR>", { noremap = true } },
         { "<leader>zd", "<CMD>Obsidian dailies -5<CR>", { noremap = true, desc = "Daily notes picker" } },
         { "<leader>zw", open_current_obsidian_weekly_note, { noremap = true, desc = "Weekly note" } },
         { "<leader>znd", "<CMD>Obsidian today<CR>", { noremap = true } },
         { "<leader>znn", "<CMD>Obsidian new<CR>", { noremap = true, desc = "New note in inbox" } },
         {
            "<leader>znh",
            create_obsidian_note_in_current_dir,
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
         },
         search = {
            max_lines = 3000,
         },
         new_notes_location = "notes_subdir",
         notes_subdir = "inbox",
         daily_notes = {
            folder = vim.fn.expand("$NOTES_DAILY_PATH"),
            date_format = "%Y-%m-%d",
            default_tags = { "daily" },
            template = "daily.md",
         },
         weekly_notes = {
            folder = "area/journal/weekly",
            date_format = "GGGG-[W]WW",
            template = "weekly.md",
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
            style = function(opts)
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
      },
   },
}
