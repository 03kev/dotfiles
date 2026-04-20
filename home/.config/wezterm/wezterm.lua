local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

local theme = require("lua.theme")
local palettes = require("lua.palettes")
local keys = require("lua.keys")
local ui = require("lua.ui")
local plugins = require("lua.plugins")

local theme_mode = theme.read_theme_mode()
local palette = palettes.get(theme_mode)

ui.apply(config, wezterm)

config.keys = keys.get(wezterm, act)
plugins.setup(config, wezterm, act)

config.colors = {
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

return config
