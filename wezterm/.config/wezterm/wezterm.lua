local wezterm = require("wezterm")
local appearance = require("appearance")
local keybinds = require("keybinds")

local config = wezterm.config_builder and wezterm.config_builder() or {}
local system_appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"

appearance.apply_to_config(config, system_appearance)
keybinds.apply_to_config(config)

config.enable_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.native_macos_fullscreen_mode = true
-- config.window_close_confirmation = "NeverPrompt"
-- config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font("JetBrains Maple Mono")
config.font_size = 14

return config
