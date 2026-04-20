local wezterm = require("wezterm")
local M = {}

function M.setup(config)
   local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

   tabline.setup({
      options = {
         icons_enabled = true,
         theme = "GruvboxDark",
      },
   })
end

return M
