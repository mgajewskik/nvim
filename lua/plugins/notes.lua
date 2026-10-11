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

-- Defaults match this machine's shell env; obsidian is skipped where the vault doesn't exist
local notes_path = vim.env.NOTES_PATH or vim.fn.expand("~/obsidian")
local notes_daily_path = vim.env.NOTES_DAILY_PATH or "area/journal/daily"

return {
   {
      "obsidian-nvim/obsidian.nvim",
      version = "*",
      lazy = false,
      cond = vim.fn.isdirectory(notes_path) == 1,
      keys = {
         { "<leader>ns", "<CMD>Obsidian search<CR>" },
         { "<leader>nf", "<CMD>Obsidian quick_switch<CR>" },
         { "<leader>nl", "<CMD>Obsidian links<CR>" },
         { "<leader>nh", "<CMD>Obsidian backlinks<CR>" },
         { "<leader>nd", "<CMD>Obsidian dailies -5<CR>", desc = "Daily notes picker" },
         { "<leader>nw", open_current_obsidian_weekly_note, desc = "Weekly note" },
         { "<leader>nnd", "<CMD>Obsidian today<CR>" },
         { "<leader>nnn", "<CMD>Obsidian new<CR>", desc = "New note in inbox" },
         {
            "<leader>nnh",
            create_obsidian_note_in_current_dir,
            desc = "New note here",
         },
         { "<leader>nnt", "<CMD>Obsidian new_from_template<CR>" },
         { "<leader>nn", "<CMD>Obsidian follow_link vsplit<CR>" },
         { "<leader>nt", "<CMD>Obsidian tags<CR>" },
         { "<leader>nr", "<CMD>Obsidian rename<CR>" },
         { "<leader>na", "<CMD>Obsidian toggle_checkbox<CR>" },
      },
      opts = {
         legacy_commands = false,
         workspaces = {
            {
               name = "notes",
               path = notes_path,
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
            folder = notes_daily_path,
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
         footer = {
            enabled = false,
         },
         checkbox = {
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
