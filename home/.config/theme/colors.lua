local M = {}

local function read_env(path)
   local values = {}
   local file = io.open(path, "r")
   if not file then
      error("cannot open shared theme colors: " .. path)
   end

   for line in file:lines() do
      local key, value = line:match('^%s*([%w_]+)%s*=%s*"(.-)"%s*$')
      if key then
         values[key] = value
      end
   end

   file:close()
   return values
end

local values = read_env((os.getenv("HOME") or "") .. "/.config/theme/colors.env")

local function v(key)
   local value = values[key]
   if value == nil then
      error("missing shared theme color: " .. key)
   end
   return value
end

local function mode(name)
   local prefix = "DOT_THEME_" .. name:upper() .. "_"

   return {
      bg = v(prefix .. "BG"),
      fg = v(prefix .. "FG"),
      soft_bg = values[prefix .. "SOFT_BG"],
      soft_fg = values[prefix .. "SOFT_FG"],
      surface = v(prefix .. "SURFACE"),
      surface_hover = v(prefix .. "SURFACE_HOVER"),
      muted = v(prefix .. "MUTED"),
      selection_bg = v(prefix .. "SELECTION_BG"),
      selection_fg = v(prefix .. "SELECTION_FG"),
      cursor = v(prefix .. "CURSOR"),
      cursor_border = values[prefix .. "CURSOR_BORDER"] or v(prefix .. "CURSOR"),
      ansi = {
         v(prefix .. "ANSI_0"),
         v(prefix .. "ANSI_1"),
         v(prefix .. "ANSI_2"),
         v(prefix .. "ANSI_3"),
         v(prefix .. "ANSI_4"),
         v(prefix .. "ANSI_5"),
         v(prefix .. "ANSI_6"),
         v(prefix .. "ANSI_7"),
      },
      brights = {
         v(prefix .. "BRIGHT_0"),
         v(prefix .. "BRIGHT_1"),
         v(prefix .. "BRIGHT_2"),
         v(prefix .. "BRIGHT_3"),
         v(prefix .. "BRIGHT_4"),
         v(prefix .. "BRIGHT_5"),
         v(prefix .. "BRIGHT_6"),
         v(prefix .. "BRIGHT_7"),
      },
   }
end

M.dark = mode("dark")
M.light = mode("light")

function M.get(name)
   if name == "light" then
      return M.light
   end
   return M.dark
end

return M
