local wezterm = require("wezterm")
local M = {}

function M.setup(config, _, palette)
   local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
   bar.apply_to_config(config, {
      position = "bottom",
      max_width = 28,
      padding = {
         left = 0,
         right = 2,
         tabs = {
            left = 1,
            right = 2,
         },
      },
      separator = {
         space = 0,
         left_icon = " ",
         right_icon = "",
         field_icon = " " .. wezterm.nerdfonts.indent_line .. " ",
      },
      modules = {
         tabs = {
            active_tab_fg = palette.tab_active_fg,
            active_tab_bg = palette.tab_active_bg,
            inactive_tab_fg = palette.tab_inactive_fg,
            inactive_tab_bg = palette.tab_inactive_bg,
            new_tab_fg = palette.tab_inactive_fg,
            new_tab_bg = palette.tab_inactive_bg,
         },
         workspace = {
            enabled = false,
         },
         leader = {
            enabled = false,
         },
         zoom = {
            enabled = false,
         },
         pane = {
            enabled = false,
         },
         username = {
            enabled = false,
         },
         hostname = {
            enabled = false,
         },
         clock = {
            enabled = false,
         },
         cwd = {
            enabled = false,
         },
         ssh = {
            enabled = false,
         },
         spotify = {
            enabled = false,
         },
      },
   })
end

return M
