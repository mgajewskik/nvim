local cmd = vim.api.nvim_create_user_command

-- vim.cmd([[command! Jfmt :%!jq .]])
-- vim.cmd([[command! MD :! litemdview % &]])
-- vim.cmd([[:command Md ! litemdview %:p & disown]])

cmd("Jfmt", "%!jq --indent 4 .", {})
cmd("MD", "! litemdview % &", {})
cmd("Md", "! litemdview %:p & disown", {})

vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ca CodeCompanionChat Add]])

vim.cmd([[cab ac Augment chat]])

vim.api.nvim_create_user_command("FormatNote", function()
   local filepath = vim.fn.expand("%:p")
   local script_path = vim.fn.expand("$NOTES_PATH") .. "/scripts/format-note.py"

   -- Save the buffer first
   vim.cmd("write")

   -- Run the format script (captures stdout and stderr)
   local result = vim.fn.system({ script_path, filepath })
   local exit_code = vim.v.shell_error

   if exit_code ~= 0 then
      vim.notify("FormatNote failed:\n" .. result, vim.log.levels.ERROR)
      return
   end

   -- Check for warnings in output and show as notifications
   for line in result:gmatch("[^\n]+") do
      if line:match("^Warning:") then
         vim.notify(line, vim.log.levels.WARN)
      end
   end

   -- Parse new filepath from output: "Renamed: old -> new" or "Updated: path"
   local new_path = result:match("Renamed:.--> (.+)") or result:match("Updated: (.+)")
   if new_path then
      new_path = vim.fn.trim(new_path)
      -- Close current buffer and open the new file
      vim.cmd("bdelete")
      vim.cmd("edit " .. vim.fn.fnameescape(new_path))
      vim.notify("Note formatted: " .. vim.fn.fnamemodify(new_path, ":t"), vim.log.levels.INFO)
   else
      vim.notify(result, vim.log.levels.INFO)
   end
end, { desc = "Format note to Zettelkasten format" })
