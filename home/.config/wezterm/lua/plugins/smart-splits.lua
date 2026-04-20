local M = {}

function M.setup(config, wezterm, act)
   local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

   smart_splits.apply_to_config(config, {
      direction_keys = { "h", "j", "k", "l" },
      modifiers = {
         move = "CTRL|SHIFT",
         resize = "ALT",
      },
   })

   table.insert(config.keys, {
      key = "w",
      mods = "CMD|SHIFT",
      action = act.CloseCurrentPane({ confirm = false }),
   })
end

return M
