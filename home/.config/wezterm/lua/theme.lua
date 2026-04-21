local wezterm = require("wezterm")
local palettes = require("lua.palettes")

local M = {}
local pane_theme_modes = {}

-- Persisted fallback used when a pane hasn't published its live theme yet.
M.default_theme_file = wezterm.home_dir .. "/.zsh/selected_theme"

function M.read_default_theme_mode()
   local f = io.open(M.default_theme_file, "r")
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

function M.resolve_runtime_theme_mode(pane)
   if pane then
      local pane_id = pane:pane_id()
      local remembered_mode = pane_theme_modes[pane_id]
      if remembered_mode then
         return remembered_mode
      end

      local vars = pane:get_user_vars()
      if vars.theme_mode then
         local mode = M.normalize_mode(vars.theme_mode)
         pane_theme_modes[pane_id] = mode
         return mode
      end
   end

   return M.read_default_theme_mode()
end

function M.resolve_runtime_theme_mode_for_pane_id(pane_id)
   local remembered_mode = pane_theme_modes[pane_id]
   if remembered_mode then
      return remembered_mode
   end

   return M.read_default_theme_mode()
end

function M.apply_window_theme_mode(window, mode)
   if not window then
      return
   end

   local overrides = window:get_config_overrides() or {}

   if overrides.theme_mode == mode and overrides.colors ~= nil then
      return
   end

   overrides.theme_mode = mode
   overrides.colors = M.get_colors(mode)
   window:set_config_overrides(overrides)
end

function M.sync_window_theme(window, pane)
   M.apply_window_theme_mode(window, M.resolve_runtime_theme_mode(pane))
end

function M.sync_window_theme_from_tab_info(tab_info)
   if not tab_info or not tab_info.window_id or not tab_info.active_pane or not tab_info.active_pane.pane_id then
      return
   end

   local mux_window = wezterm.mux.get_window(tab_info.window_id)
   if not mux_window then
      return
   end

   local gui_window = mux_window:gui_window()
   if not gui_window then
      return
   end

   local mode = M.resolve_runtime_theme_mode_for_pane_id(tab_info.active_pane.pane_id)
   M.apply_window_theme_mode(gui_window, mode)
end

function M.setup(wezterm)
   wezterm.on("user-var-changed", function(window, pane, name, value)
      if name ~= "theme_mode" then
         return
      end

      local mode = M.normalize_mode(value)
      pane_theme_modes[pane:pane_id()] = mode
      M.apply_window_theme_mode(window, mode)
   end)

   wezterm.on("window-config-reloaded", function(window, pane)
      M.sync_window_theme(window, pane)
   end)

   wezterm.on("window-focus-changed", function(window, pane)
      M.sync_window_theme(window, pane)
   end)

   wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
      M.sync_window_theme_from_tab_info(tab)
      return tab.window_title or pane.title or ""
   end)
end

return M
