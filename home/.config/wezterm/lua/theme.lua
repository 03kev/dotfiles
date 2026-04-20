local wezterm = require("wezterm")

local M = {}

M.theme_file = wezterm.home_dir .. "/.zsh/selected_theme"

wezterm.add_to_config_reload_watch_list(M.theme_file)

function M.read_theme_mode()
   local f = io.open(M.theme_file, "r")
   if not f then
      return "dark"
   end

   local mode = f:read("*l")
   f:close()

   if mode == "light" then
      return "light"
   end

   return "dark"
end

return M
