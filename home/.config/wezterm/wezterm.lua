local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

local theme_file = wezterm.home_dir .. "/.zsh/selected_theme"

wezterm.add_to_config_reload_watch_list(theme_file)

local function read_theme_mode()
	local f = io.open(theme_file, "r")
	if not f then
		return "dark"
	end

	local mode = f:read("*l")
	f:close()

	if mode == "light" then
		return "light"
	end

	return "dark"
end

local theme_mode = read_theme_mode()

local palette
if theme_mode == "light" then
	palette = {
		foreground = "#10100f",
		background = "#edebdc",

		cursor_bg = "#8f8e72",
		cursor_fg = "#f9f9f9",
		cursor_border = "#8f8e72",

		selection_fg = "#10100f",
		selection_bg = "#d8d3bf",

		tab_bar_bg = "#d7d3c6",
		tab_active_bg = "#edebdc",
		tab_active_fg = "#10100f",
		tab_inactive_bg = "#d7d3c6",
		tab_inactive_fg = "#6e6b62",
		tab_hover_bg = "#e4e0d2",
		tab_hover_fg = "#10100f",

		ansi = {
			"#10100f",
			"#a14a44",
			"#5f7a14",
			"#b59a2c",
			"#6b6b6b",
			"#8a5a7a",
			"#4f7f7f",
			"#d8d5c9",
		},

		brights = {
			"#5f5d57",
			"#b35a53",
			"#6d8a0f",
			"#c2a93a",
			"#7c7c7c",
			"#9a6a8a",
			"#5d8f8f",
			"#f5f2e8",
		},
	}
else
	palette = {
		foreground = "#f9f9f9",
		background = "#1d1d1b",

		cursor_bg = "#8f8e72",
		cursor_fg = "#f9f9f9",
		cursor_border = "#8f8e72",

		selection_fg = "#f9f9f9",
		selection_bg = "#2a2a26",

		tab_bar_bg = "#0b0b0a",
		tab_active_bg = "#1a1a18",
		tab_active_fg = "#f9f9f9",
		tab_inactive_bg = "#0b0b0a",
		tab_inactive_fg = "#7b7a72",
		tab_hover_bg = "#161615",
		tab_hover_fg = "#f9f9f9",
	}
end

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
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
config.default_cwd = wezterm.home_dir

config.colors = {
	foreground = palette.foreground,
	background = palette.background,

	ansi = palette.ansi,
	brights = palette.brights,

	cursor_bg = palette.cursor_bg,
	cursor_fg = palette.cursor_fg,
	cursor_border = palette.cursor_border,

	selection_fg = palette.selection_fg,
	selection_bg = palette.selection_bg,

	tab_bar = {
		background = palette.tab_bar_bg,

		active_tab = {
			bg_color = palette.tab_active_bg,
			fg_color = palette.tab_active_fg,
			intensity = "Bold",
		},

		inactive_tab = {
			bg_color = palette.tab_inactive_bg,
			fg_color = palette.tab_inactive_fg,
		},

		inactive_tab_hover = {
			bg_color = palette.tab_hover_bg,
			fg_color = palette.tab_hover_fg,
			italic = false,
		},

		new_tab = {
			bg_color = palette.tab_inactive_bg,
			fg_color = palette.tab_inactive_fg,
		},

		new_tab_hover = {
			bg_color = palette.tab_hover_bg,
			fg_color = palette.tab_hover_fg,
		},
	},
}

config.keys = {
	{
		key = "t",
		mods = "CMD",
		action = act.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
		}),
	},
	{
		key = "w",
		mods = "CMD",
		action = act.CloseCurrentTab({ confirm = false }),
	},
}

return config
