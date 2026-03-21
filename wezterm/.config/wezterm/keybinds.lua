local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
	config.keys = {
		{
			key = "d",
			mods = "CMD",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "D",
			mods = "CMD|SHIFT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "[",
			mods = "CMD",
			action = act.ActivatePaneDirection("Prev"),
		},
		{
			key = "]",
			mods = "CMD",
			action = act.ActivatePaneDirection("Next"),
		},
	}
end

return M
