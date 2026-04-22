local M = {}

function M.setup(config, wezterm, act, palette)
   require("lua.plugins.smart-splits").setup(config, wezterm, act)
   require("lua.tab_titles").setup(wezterm)
   require("lua.plugins.bar").setup(config, wezterm, palette)
   require("lua.right_status").setup(wezterm)
end

return M
