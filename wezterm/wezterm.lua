local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font Size
config.font_size = 17.0

-- Font Family
config.font = wezterm.font("MesloLGS Nerd Font")

-- Cursor Blink Rate
config.cursor_blink_rate = 0

-- Use a dark base, not Github Light
config.color_scheme = "One Dark (Gogh)"

config.colors = {
	background = "#282C34",
	foreground = "#FFFFFF",
	cursor_bg = "#FFFFFF",
	cursor_fg = "#282C34",
	selection_bg = "#3E4452",
	selection_fg = "#FFFFFF",

	ansi = {
		"#3B4048", -- black
		"#FF6B6B", -- red
		"#98C379", -- green
		"#E5C07B", -- yellow
		"#61AFEF", -- blue
		"#C678DD", -- magenta
		"#56B6C2", -- cyan
		"#FFFFFF", -- white
	},

	brights = {
		"#5C6370", -- bright black
		"#FF7B7B", -- bright red
		"#A9DC76", -- bright green
		"#FFD866", -- bright yellow
		"#6CB6FF", -- bright blue
		"#D38AEA", -- bright magenta
		"#6BDFFF", -- bright cyan
		"#FFFFFF", -- bright white
	},
}

-- Keep it solid, not transparent
config.window_background_opacity = 1.0

-- Gets rid of the title bar
config.window_decorations = "RESIZE"

-- Removes tabs
config.enable_tab_bar = false

-- FPS
config.max_fps = 120

config.enable_kitty_graphics = true

return config
