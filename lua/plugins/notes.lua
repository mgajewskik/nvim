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
         { "<leader>zd", "<CMD>Obsidian dailies -2 1<CR>", { noremap = true } },
         { "<leader>znd", "<CMD>Obsidian today<CR>", { noremap = true } },
         {
            "<leader>znn",
            function()
               local title = vim.fn.input("Note title: ")
               vim.cmd("Obsidian new_from_template " .. title .. " zettelkasten")
            end,
            { noremap = true, desc = "New note from zettelkasten template" },
         },
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
                     vim.cmd("Obsidian new_from_template " .. input .. " zettelkasten")
                  end
               end)
            end,
            desc = "New zettelkasten note here",
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
            -- nvim_cmp = false,
            blink = true,
            min_chars = 2,
         },
         new_notes_location = "notes_dir",
         daily_notes = {
            folder = vim.fn.expand("$NOTES_DAILY_PATH"),
            date_format = "%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            -- alias_format = "%B %-d, %Y",
            -- Optional, default tags to add to each new daily note created.
            default_tags = { "daily" },
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = "daily.md",
         },
         templates = {
            folder = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            substitutions = {
               alias = function(ctx)
                  if ctx.partial_note and ctx.partial_note.id then
                     local id = ctx.partial_note.id
                     -- Zettelkasten format: YYYYMMDDHHMM-title
                     local extracted = id:match("^%d+%-(.+)$")
                     if extracted then
                        return extracted
                     end
                     -- Periodic notes: return ID as-is (2026-Q1, 2026-W01, etc.)
                     if id:match("^%d%d%d%d%-") or id:match("^%d%d%d%d$") then
                        return id
                     end
                  end
                  return ""
               end,
            },
         },
         attachments = {
            folder = "media",
         },
         ui = {
            enable = true,
         },
         checkbox = {
            enabled = true,
            create_new = true,
            order = { " ", "x" },
         },
         frontmatter = {
            enabled = true,
            sort = { "id", "aliases", "tags" },
            func = function(note)
               -- Preserve existing aliases and add title/filename as alias
               local aliases = note.aliases or {}
               local alias_to_add = note.title

               -- Fallback: extract from ID if title is nil
               if (not alias_to_add or alias_to_add == "") and note.id then
                  local id = note.id
                  -- Periodic notes: use ID as-is
                  if
                     id:match("^%d%d%d%d%-%d%d%-%d%d$") -- Daily
                     or id:match("^%d%d%d%d%-Q%d$") -- Quarterly
                     or id:match("^%d%d%d%d%-W%d%d?$") -- Weekly
                     or id:match("^%d%d%d%d%-%d%d$") -- Monthly
                     or id:match("^%d%d%d%d$") -- Yearly
                  then
                     alias_to_add = id
                  else
                     -- Zettelkasten: extract from YYYYMMDDHHMM-title (12 digits)
                     local extracted = id:match("^%d%d%d%d%d%d%d%d%d%d%d%d%-(.+)$")
                     if extracted and extracted ~= "inbox" then
                        alias_to_add = extracted
                     end
                  end
               end

               if alias_to_add and alias_to_add ~= "" and not vim.tbl_contains(aliases, alias_to_add) then
                  table.insert(aliases, alias_to_add)
               end

               -- Preserve existing tags
               local tags = note.tags or {}

               -- Add "daily" tag only for notes in daily folder (merge, no dups)
               local full_path = vim.fn.expand("%:p")
               local dir = full_path ~= "" and vim.fn.fnamemodify(full_path, ":h") or ""
               if dir ~= "" and string.find(dir:lower(), "daily") then
                  if not vim.tbl_contains(tags, "daily") then
                     table.insert(tags, "daily")
                  end
               end

               -- Add "inbox" tag for notes whose ID ends with "-inbox"
               if note.id and note.id:match("%-inbox$") then
                  if not vim.tbl_contains(tags, "inbox") then
                     table.insert(tags, "inbox")
                  end
               end

               -- Add "untagged" only if still empty and has title (for normal notes)
               if #tags == 0 and note.title then
                  table.insert(tags, "untagged")
               end

               -- Build the base frontmatter
               local out = {
                  id = note.id,
                  aliases = aliases,
                  tags = tags,
               }

               -- Merge in any additional custom metadata
               if note.metadata and not vim.tbl_isempty(note.metadata) then
                  for k, v in pairs(note.metadata) do
                     if out[k] == nil then
                        out[k] = v
                     end
                  end
               end

               return out
            end,
         },
         note_id_func = function(title)
            if not title or title == "" then
               return os.date("%Y%m%d%H%M") .. "-inbox"
            end
            -- Periodic note patterns - pass through as-is
            if
               title:match("^%d%d%d%d%-%d%d%-%d%d$") -- Daily: 2024-12-30
               or title:match("^%d%d%d%d%-Q%d$") -- Quarterly: 2026-Q1
               or title:match("^%d%d%d%d%-W%d%d?$") -- Weekly: 2026-W01
               or title:match("^%d%d%d%d%-%d%d$") -- Monthly: 2026-01
               or title:match("^%d%d%d%d$") -- Yearly: 2026
            then
               return title
            end
            -- Regular zettelkasten
            local timestamp = os.date("%Y%m%d%H%M")
            local safe_title = title:gsub("[/\\:]", "-")
            return string.format("%s-%s", timestamp, safe_title:gsub(" ", "-"):lower())
         end,
         wiki_link_func = function(opts)
            if opts.label then
               return string.format("[[%s|%s]]", opts.path, opts.label)
            else
               return string.format("[[%s]]", opts.path)
            end
         end,
      },
   },
}
