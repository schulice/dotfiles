local wezterm = require("wezterm")

local M = {}

local TAB_BAR_FONT = wezterm.font({ family = "Roboto", weight = "Bold" })
local TAB_BAR_FONT_SIZE = 14.0

local themes = {
	light = {
		scheme = "One Light (base16)",

		window_frame = {
			font = TAB_BAR_FONT,
			font_size = TAB_BAR_FONT_SIZE,
			active_titlebar_bg = "#EAEAEB",
			inactive_titlebar_bg = "#DCDFE4",
		},

		colors = {
			tab_bar = {
				background = "#EAEAEB",
				inactive_tab_edge = "#D0D3D8",

				active_tab = {
					bg_color = "#F9F9F9",
					fg_color = "#383A42",
					intensity = "Bold",
					underline = "None",
					italic = false,
					strikethrough = false,
				},

				inactive_tab = {
					bg_color = "#EAEAEB",
					fg_color = "#6B7280",
					intensity = "Normal",
					underline = "None",
					italic = false,
					strikethrough = false,
				},

				inactive_tab_hover = {
					bg_color = "#F0F0F1",
					fg_color = "#383A42",
					italic = false,
				},

				new_tab = {
					bg_color = "#EAEAEB",
					fg_color = "#6B7280",
				},

				new_tab_hover = {
					bg_color = "#F0F0F1",
					fg_color = "#383A42",
					italic = false,
				},
			},
		},
	},

	dark = {
		scheme = "OneDark (base16)",

		window_frame = {
			font = TAB_BAR_FONT,
			font_size = TAB_BAR_FONT_SIZE,
			active_titlebar_bg = "#21252B",
			inactive_titlebar_bg = "#1B1F24",
		},

		colors = {
			tab_bar = {
				background = "#21252B",
				inactive_tab_edge = "#2A2F36",

				active_tab = {
					bg_color = "#282C34",
					fg_color = "#E6EAF2",
					intensity = "Bold",
					underline = "None",
					italic = false,
					strikethrough = false,
				},

				inactive_tab = {
					bg_color = "#21252B",
					fg_color = "#7F8793",
					intensity = "Normal",
					underline = "None",
					italic = false,
					strikethrough = false,
				},

				inactive_tab_hover = {
					bg_color = "#252A32",
					fg_color = "#ABB2BF",
					italic = false,
				},

				new_tab = {
					bg_color = "#21252B",
					fg_color = "#7F8793",
				},

				new_tab_hover = {
					bg_color = "#252A32",
					fg_color = "#ABB2BF",
					italic = false,
				},
			},
		},
	},
}

function M.apply_to_config(config, system_appearance)
	local is_dark = system_appearance and system_appearance:find("Dark")
	local theme = is_dark and themes.dark or themes.light

	config.color_scheme = theme.scheme
	config.window_frame = theme.window_frame
	config.colors = theme.colors
end

return M
