-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- Get system theme

local appearance_themes = {
	Light = "rose-pine-dawn",
	Dark = "zenbones_dark",
}

-- For example, changing the color scheme =
-- config.color_scheme = 'Sakura (base16)'
-- config.color_scheme = "AtomOneLight"
-- config.color_scheme = 'zenbones_dark'
local appearance = wezterm.gui.get_appearance()
config.color_scheme = appearance_themes[appearance]

-- Windows and size
config.window_decorations = "RESIZE"
config.initial_cols = 150
config.initial_rows = 40

-- Tabs
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.enable_scroll_bar = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Text
config.font = wezterm.font_with_fallback({
	{
		family = "FiraCode Nerd Font Mono",
		-- weight = "Regular"
	},
	"RobotoMono Nerd Font Mono",
	"MesloLGL Nerd Font Mono",
})

config.font_size = 14.5

-- and finally, return the configuration to wezterm
return config
