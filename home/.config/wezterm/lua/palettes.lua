local colors = dofile(os.getenv("HOME") .. "/.config/theme/colors.lua")

local M = {}

local function terminal_palette(mode)
   local c = colors.get(mode)

   return {
      foreground = c.fg,
      background = c.bg,
      status_text_color = 5,

      cursor_bg = c.cursor,
      cursor_fg = colors.dark.fg,
      cursor_border = c.cursor_border,

      selection_fg = c.selection_fg,
      selection_bg = c.selection_bg,

      tab_bar_bg = c.surface,
      tab_active_bg = c.bg,
      tab_active_fg = c.fg,
      tab_inactive_bg = c.surface,
      tab_inactive_fg = c.muted,
      tab_hover_bg = c.surface_hover,
      tab_hover_fg = c.fg,

      ansi = c.ansi,
      brights = c.brights,
   }
end

function M.get(mode)
   if mode == "light" then
      return terminal_palette("light")
   end
   return terminal_palette("dark")
end

return M
