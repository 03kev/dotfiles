local wezterm = require("wezterm")
local M = {}

local function basename(value)
   if type(value) ~= "string" or value == "" then
      return nil
   end

   local name = value:match("[^/\\]*$")
   if not name or name == "" then
      return nil
   end

   return (name:gsub("(.+)%.%w+$", "%1"))
end

local function icon(candidates, fallback)
   for _, name in ipairs(candidates) do
      local glyph = name and wezterm.nerdfonts[name]
      if glyph then
         return glyph
      end
   end

   return fallback
end

local function resolve_icon(process_name)
   local icons = {
      zsh = icon({ "dev_terminal" }, ""),
      bash = icon({ "cod_terminal_bash", "dev_terminal" }, ""),
      fish = icon({ "dev_terminal" }, "󰈺"),
      nu = icon({ "dev_terminal" }, "󰫢"),
      tmux = icon({ "cod_multiple_windows" }, ""),
      vim = icon({ "dev_vim", "custom_vim" }, ""),
      nvim = icon({ "custom_vim", "dev_vim" }, ""),
      git = icon({ "dev_git" }, ""),
      lazygit = icon({ "dev_git", "dev_github_alt" }, ""),
      gh = icon({ "dev_github_badge", "dev_github" }, ""),
      ssh = icon({ "md_ssh" }, "󰣀"),
      docker = icon({ "linux_docker" }, ""),
      ["docker-compose"] = icon({ "linux_docker" }, ""),
      kubectl = icon({ "linux_docker" }, "󱃾"),
      terraform = icon({ "seti_terraform" }, ""),
      node = icon({ "md_hexagon" }, ""),
      bun = icon({ "md_hexagon" }, ""),
      deno = icon({ "md_hexagon" }, ""),
      npm = icon({ "md_npm" }, ""),
      pnpm = icon({ "md_package_variant_closed", "md_npm" }, "󰏗"),
      python = icon({ "dev_python" }, ""),
      ipython = icon({ "dev_python" }, ""),
      lua = icon({ "seti_lua" }, ""),
      go = icon({ "seti_go" }, ""),
      cargo = icon({ "dev_rust" }, ""),
      rustc = icon({ "dev_rust" }, ""),
      ruby = icon({ "cod_ruby" }, ""),
      java = icon({ "seti_java" }, ""),
      javac = icon({ "seti_java" }, ""),
      make = icon({ "seti_makefile" }, ""),
      just = icon({ "seti_makefile" }, "󰔟"),
      yazi = icon({ "oct_file_directory" }, ""),
      lf = icon({ "oct_file_directory" }, ""),
      ranger = icon({ "oct_file_directory" }, ""),
      btop = icon({ "md_chart_timeline_variant" }, "󰄪"),
      htop = icon({ "md_chart_timeline_variant" }, "󰓅"),
      psql = icon({ "dev_postgresql" }, ""),
      postgres = icon({ "dev_postgresql" }, ""),
      mysql = icon({ "dev_mysql" }, ""),
   }

   return icons[process_name] or icon({ "cod_terminal", "dev_terminal" }, "")
end

local function resolve_label(pane, process_name)
   local pane_title = basename(pane:get_title())
   if pane_title and pane_title ~= "wezterm" and pane_title ~= process_name then
      return pane_title
   end

   if process_name and process_name ~= "" then
      return process_name
   end

   return "shell"
end

function M.setup(wezterm)
   wezterm.on("update-status", function(_, pane)
      if not pane then
         return
      end

      local tab = pane:tab()
      if not tab then
         return
      end

      local process_name = basename(pane:get_foreground_process_name()) or ""
      local title = string.format("%s %s", resolve_icon(process_name), resolve_label(pane, process_name))

      if tab:get_title() ~= title then
         tab:set_title(title)
      end
   end)
end

return M
