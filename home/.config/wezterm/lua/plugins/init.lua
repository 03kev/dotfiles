local M = {}

function M.setup(config, wezterm, act)
   require("lua.plugins.smart-splits").setup(config, wezterm, act)
   require("lua.plugins.bar").setup(config)
end

return M
