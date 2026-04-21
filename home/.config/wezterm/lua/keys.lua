local M = {}

function M.get(wezterm, act)
   return {
      {
         key = "t",
         mods = "CMD",
         action = act.SpawnCommandInNewTab({
            cwd = wezterm.home_dir,
         }),
      },
      {
         key = "n",
         mods = "CMD",
         action = act.SpawnCommandInNewWindow({
            cwd = wezterm.home_dir,
         }),
      },
      {
         key = "w",
         mods = "CMD",
         action = act.CloseCurrentTab({ confirm = false }),
      },
      {
         key = "d",
         mods = "CMD",
         action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
      },
      {
         key = "d",
         mods = "CMD|SHIFT",
         action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
      },
      {
         key = "L",
         mods = "CMD|SHIFT",
         action = act.ShowDebugOverlay,
      },
   }
end

return M
