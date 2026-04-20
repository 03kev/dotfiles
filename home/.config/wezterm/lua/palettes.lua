local M = {}

local palettes = {
   light = {
      foreground = "#10100f",
      background = "#edebdc",
      status_text_color = 5,

      cursor_bg = "#64635a",
      cursor_fg = "#f9f9f9",
      cursor_border = "#8f8e72",

      selection_fg = "#10100f",
      selection_bg = "#d8d3bf",

      tab_bar_bg = "#d7d3c6",
      tab_active_bg = "#edebdc",
      tab_active_fg = "#10100f",
      tab_inactive_bg = "#d7d3c6",
      tab_inactive_fg = "#6e6b62",
      tab_hover_bg = "#e4e0d2",
      tab_hover_fg = "#10100f",

      ansi = {
         "#10100f",
         "#a14a44",
         "#5f7a14",
         "#b59a2c",
         "#6b6b6b",
         "#8a5a7a",
         "#4f7f7f",
         "#d8d5c9",
      },

      brights = {
         "#5f5d57",
         "#b35a53",
         "#6d8a0f",
         "#c2a93a",
         "#7c7c7c",
         "#9a6a8a",
         "#5d8f8f",
         "#f5f2e8",
      },
   },

   dark = {
      foreground = "#f9f9f9",
      background = "#1d1d1b",
      status_text_color = 5,

      cursor_bg = "#8f8e72",
      cursor_fg = "#f9f9f9",
      cursor_border = "#8f8e72",

      selection_fg = "#f9f9f9",
      selection_bg = "#2a2a26",

      tab_bar_bg = "#0b0b0a",
      tab_active_bg = "#1d1d1b",
      tab_active_fg = "#f9f9f9",
      tab_inactive_bg = "#0b0b0a",
      tab_inactive_fg = "#9e9a8f",
      tab_hover_bg = "#161615",
      tab_hover_fg = "#f9f9f9",

      ansi = {
         "#1d1d1b",
         "#c05a52",
         "#6d8a0f",
         "#d2b34c",
         "#7c7c7c",
         "#a07090",
         "#5d8f8f",
         "#d8d5c9",
      },

      brights = {
         "#6b6963",
         "#d06a62",
         "#7ca315",
         "#e0c15a",
         "#8d8d8d",
         "#b080a0",
         "#6fa1a1",
         "#f5f2e8",
      },
   },
}

function M.get(mode)
   return palettes[mode] or palettes.dark
end

return M
