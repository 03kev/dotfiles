local wezterm = require("wezterm")

local M = {}

local function basename(value)
   if type(value) ~= "string" or value == "" then
      return nil
   end

   local name = value:match("[^/\\]*$")
   if not name or name == "" then
      return nil
   end

   return (name:gsub("(.+)%.%w+$", "%1"))
end

local function decode_cwd(pane)
   if not pane then
      return ""
   end

   local cwd_uri = pane:get_current_working_dir()
   if not cwd_uri then
      return ""
   end

   local cwd = ""
   if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path or ""
   else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find("/")
      if slash then
         cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
            local n = tonumber(hex, 16)
            if not n then
               return "-"
            end
            return string.char(n)
         end)
      end
   end

   if cwd == "" then
      return ""
   end

   local home = wezterm.home_dir:gsub("\\", "/")
   cwd = cwd:gsub("\\", "/")
   cwd = cwd:gsub("^" .. home, "~")

   return cwd
end

function M.setup(wezterm)
   wezterm.on("update-status", function(window, pane)
      if not window or not pane then
         return
      end

      local sep = " " .. wezterm.nerdfonts.indent_line .. " "
      local parts = { wezterm.time.now():format("%H:%M") }

      local process_name = basename(pane:get_foreground_process_name()) or ""
      if process_name:match("ssh$") then
         table.insert(parts, "ssh")
      else
         local cwd = decode_cwd(pane)
         if cwd ~= "" then
            table.insert(parts, cwd)
         end
      end

      local items = { { Text = "  " } }

      for index, part in ipairs(parts) do
         if index > 1 then
            table.insert(items, { Text = sep })
         end

         table.insert(items, { Text = part })
      end

      table.insert(items, { Text = "  " })

      window:set_right_status(wezterm.format(items))
   end)
end

return M
