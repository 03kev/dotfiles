local M = {}

function M.apply(config, wezterm)
   config.enable_tab_bar = true
   config.hide_tab_bar_if_only_one_tab = true
   -- config.use_fancy_tab_bar = false
   config.window_decorations = "RESIZE"
   config.window_close_confirmation = "NeverPrompt"

   config.font = wezterm.font("JetBrainsMono Nerd Font", {
      weight = "Regular",
   })

   config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

   config.font_size = 13.0
   config.line_height = 1.0
   config.cell_width = 1.0

   config.window_padding = {
      left = 8,
      right = 8,
      top = 8,
      bottom = 6,
   }

   config.default_cursor_style = "SteadyBlock"
   config.cursor_thickness = "1px"
   config.default_cwd = wezterm.home_dir
end

return M
