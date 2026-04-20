local wezterm = require("wezterm")
local palettes = require("lua.palettes")

local M = {}

M.theme_file = wezterm.home_dir .. "/.zsh/selected_theme"

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

function M.normalize_mode(mode)
   if mode == "light" then
      return "light"
   end

   return "dark"
end

function M.get_palette(mode)
   return palettes.get(M.normalize_mode(mode))
end

function M.get_colors(mode)
   local palette = M.get_palette(mode)

   return {
      foreground = palette.foreground,
      background = palette.background,

      ansi = palette.ansi,
      brights = palette.brights,

      cursor_bg = palette.cursor_bg,
      cursor_fg = palette.cursor_fg,
      cursor_border = palette.cursor_border,

      selection_fg = palette.selection_fg,
      selection_bg = palette.selection_bg,

      tab_bar = {
         background = palette.tab_bar_bg,

         active_tab = {
            bg_color = palette.tab_active_bg,
            fg_color = palette.tab_active_fg,
            intensity = "Bold",
         },

         inactive_tab = {
            bg_color = palette.tab_inactive_bg,
            fg_color = palette.tab_inactive_fg,
         },

         inactive_tab_hover = {
            bg_color = palette.tab_hover_bg,
            fg_color = palette.tab_hover_fg,
            italic = false,
         },

         new_tab = {
            bg_color = palette.tab_inactive_bg,
            fg_color = palette.tab_inactive_fg,
         },

         new_tab_hover = {
            bg_color = palette.tab_hover_bg,
            fg_color = palette.tab_hover_fg,
         },
      },
   }
end

function M.resolve_mode(pane)
   if pane then
      local vars = pane:get_user_vars()
      if vars.theme_mode then
         return M.normalize_mode(vars.theme_mode)
      end
   end

   return M.read_theme_mode()
end

function M.sync_window(window, pane)
   if not window then
      return
   end

   local mode = M.resolve_mode(pane)
   local overrides = window:get_config_overrides() or {}

   if overrides.theme_mode == mode and overrides.colors ~= nil then
      return
   end

   overrides.theme_mode = mode
   overrides.colors = M.get_colors(mode)
   window:set_config_overrides(overrides)
end

function M.setup(wezterm)
   wezterm.on("user-var-changed", function(window, pane, name, value)
      if name ~= "theme_mode" then
         return
      end

      local overrides = window:get_config_overrides() or {}
      local mode = M.normalize_mode(value)

      if overrides.theme_mode == mode and overrides.colors ~= nil then
         return
      end

      overrides.theme_mode = mode
      overrides.colors = M.get_colors(mode)
      window:set_config_overrides(overrides)
   end)

   wezterm.on("window-config-reloaded", function(window, pane)
      M.sync_window(window, pane)
   end)

   wezterm.on("window-focus-changed", function(window, pane)
      M.sync_window(window, pane)
   end)
end

return M
