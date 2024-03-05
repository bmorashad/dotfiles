-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = { "/usr/bin/fish", "-l" }

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
-- config.color_scheme = "3024 (dark) (terminal.sexy)"
-- config.color_scheme = "3024 (base16)"

-- and finally, return the configuration to wezterm

-- config.font = wezterm.font("Fira Code")
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = 600, scale = 1.8 })
config.font_size = 11.6
config.freetype_load_flags = "DEFAULT"
-- config.bold_brightens_ansi_colors = false
-- config.front_end = "WebGpu"
-- config.dpi = 144.0
config.freetype_render_target = "Light"
config.freetype_load_target = "Light"
config.bold_brightens_ansi_colors = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- other configs
local act = wezterm.action
config.keys = {

	-- ...

	{ key = "n", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(1) },
	{ key = "b", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

	{ key = "<", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = ">", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	{ key = "h", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },

	-- ...
}

config.window_decorations = "NONE"
config.tab_max_width = 16
-- config.tab_bar_at_bottom = true

config.use_fancy_tab_bar = false

wezterm.on("update-right-status", function(window)
	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S   ")
	window:set_right_status(wezterm.format({
		{ Text = date },
	}))
end)

wezterm.on("format-tab-title", function(tab, _, _, _, _)
	return {
		{ Text = " " .. tab.tab_index + 1 .. " " },
	}
end)

local window_min = " 󰖰 "
local window_max = " 󰖯 "
local window_close = " 󰅖 "

config.tab_bar_style = {
	window_hide = window_min,
	window_hide_hover = window_min,
	window_maximize = window_max,
	window_maximize_hover = window_max,
	window_close = window_close,
	window_close_hover = window_close,
}

config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
-- config.color_scheme = "Catppuccin Frappe"
config.line_height = 1.03
config.cell_width = 1.0

config.inactive_pane_hsb = {
	saturation = 0.4,
	brightness = 0.8,
}

return config
