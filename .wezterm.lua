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
-- config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = 500 })
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = 600, scale = 1.0 },
	-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 11.6
config.freetype_load_flags = "DEFAULT"
-- config.bold_brightens_ansi_colors = false
config.front_end = "OpenGL"
-- config.dpi = 144.0
config.freetype_load_target = "Light"
config.freetype_render_target = "Light" -- Test and set to Light
config.bold_brightens_ansi_colors = false
config.window_background_opacity = 0.97

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

wezterm.on("update-right-status", function(window, pane)
	local cols = pane:get_dimensions().cols
	local user_vars = pane:get_user_vars()

	local icon = user_vars.tab_icon
	if not icon or icon == "" then
		-- fallback for the icon,
		icon = "⌘"
	end

	local icon_color = user_vars.tab_color
	if not icon_color then
		icon_color = "green"
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#222222" } },
		{ Foreground = { Color = icon_color } },
		{ Text = " " .. wezterm.pad_right(icon, 2) },
	}))

	local title = pane:get_title()
	local date = " " .. wezterm.strftime("%d/%m %H:%M") .. " "
	local day = " " .. wezterm.strftime("%d/%m") .. " "
	local time = " " .. wezterm.strftime("%H:%M") .. " "

	-- generate padding to center title by adding half of width (cols), half
	-- of title length, length of date string and integrated buttons width
	--
	-- the 1 at the end is cause of extra space after date to separate it from
	-- buttons
	--
	-- if there are any theming in date or title use `wezterm.column.width`
	local padding = wezterm.pad_right("", (cols / 2) - (string.len(title) / 2) - string.len(date) - 3 * 3 - 1)

	window:set_right_status(wezterm.format({
		{ Background = { Color = "#555555" } },
		{ Foreground = { Color = "#111" } },
		{ Text = " " .. title .. " " },
		{ Background = { Color = "#333333" } },
		{ Text = padding },
		{ Background = { Color = "#666666" } },
		{ Foreground = { Color = "#111" } },
		{ Text = day },
		{ Background = { Color = "#999" } },
		{ Foreground = { Color = "#111" } },
		{ Text = time },
		{ Background = { Color = "#333333" } },
		{ Text = " " },
	}))
end)

-- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#2b2042"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width - 3)
	title = wezterm.truncate_right(title, max_width - 2 - 3)
	title = " " .. title .. " "
	local tab_index = " " .. tab.tab_index + 1 .. " "

	return {
		-- { Text = SOLID_LEFT_ARROW },
		-- { Background = { Color = "#111" } },
		-- { Foreground = { Color = "999" } },
		-- { Text = tab_index },
		-- { Background = { Color = "#111" } },
		-- { Foreground = { Color = foreground } },
		{ Text = title },
		-- { Background = { Color = edge_background } },
		-- { Foreground = { Color = edge_foreground } },
		-- { Text = SOLID_RIGHT_ARROW },
	}
end)

wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
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

config.window_decorations = "INTEGRATED_BUTTONS|NONE"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
-- config.color_scheme = "Catppuccin Frappe"
config.line_height = 1.03
config.cell_width = 1.0

config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 0.8,
	brightness = 0.4,
}
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0, -- default is 1.0
}

config.colors = {
	-- background = "#1c1c1c",
}

-- config.use_cap_height_to_scale_fallback_fonts = false

return config
