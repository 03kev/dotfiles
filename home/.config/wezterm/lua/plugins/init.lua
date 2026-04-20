local M = {}

function M.setup(config, wezterm, act, palette)
   require("lua.plugins.smart-splits").setup(config, wezterm, act)
   require("lua.tab_titles").setup(wezterm)
   require("lua.plugins.bar").setup(config, wezterm, palette)
end

return M
