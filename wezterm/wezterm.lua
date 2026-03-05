local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font Size
config.font_size = 23.0

-- Font Family
config.font = wezterm.font("MesloLGS Nerd Font")

-- Cursor Blink Rate
config.cursor_blink_rate = 0

config.color_scheme = "Catppuccin Mocha"

-- Gets rid of the title bar
config.window_decorations = "RESIZE"

-- Removes tabs
config.enable_tab_bar = false

-- FPS
config.max_fps = 120

return config
