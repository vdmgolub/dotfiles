local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- Appearance
config.front_end = "OpenGL"
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 19
config.window_decorations = "RESIZE"

-- Leader key
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1000 }

-- Smart splits: seamless navigation between wezterm panes and nvim splits
local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action({ SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.keys = {
	-- Splits
	{ mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "=", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "m", action = act.TogglePaneZoomState },

	-- Tabs
	{ mods = "LEADER", key = "c", action = act.SpawnTab("CurrentPaneDomain") },
	{ mods = "LEADER", key = "p", action = act.ActivateTabRelative(-1) },
	{ mods = "LEADER", key = "n", action = act.ActivateTabRelative(1) },
	{ mods = "LEADER", key = "1", action = act.ActivateTab(0) },
	{ mods = "LEADER", key = "2", action = act.ActivateTab(1) },
	{ mods = "LEADER", key = "3", action = act.ActivateTab(2) },
	{ mods = "LEADER", key = "4", action = act.ActivateTab(3) },
	{ mods = "LEADER", key = "5", action = act.ActivateTab(4) },
	{ mods = "LEADER", key = "6", action = act.ActivateTab(5) },
	{ mods = "LEADER", key = "7", action = act.ActivateTab(6) },
	{ mods = "LEADER", key = "8", action = act.ActivateTab(7) },
	{ mods = "LEADER", key = "9", action = act.ActivateTab(8) },

	-- Lazygit
	{ mods = "LEADER", key = "g", action = act.EmitEvent("open-lazygit") },

	-- Pane navigation / resize (smart-splits)
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
	},
}

-- Plugins
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = "",
		},
		component_separators = { left = "", right = "" },
		tab_separators = { left = "", right = "" },
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = {},
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = {},
		tabline_y = {},
		tabline_z = {},
	},
	extensions = {},
})
tabline.apply_to_config(config)

local workspace_picker = wezterm.plugin.require("https://github.com/vdmgolub/workspace_picker.wezterm")
workspace_picker.setup({
	colors = {
		workspace_prefix = "#a6e3a1",
		zoxide_prefix = "#f38ba8",
		current_indicator = "#a6e3a1",
		text = "#cdd6f4",
		path = "#6c7086",
	},
	keybinds = {
		show_picker = { mods = "LEADER", key = "s" },
		create_workspace = { mods = "LEADER", key = "S" },
		rename_workspace = { mods = "LEADER", key = "r" },
	},
})
workspace_picker.apply_to_config(config)

-- Events
local function get_cwd(pane)
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		return cwd_uri.file_path
	end
	return wezterm.home_dir
end

wezterm.on("open-lazygit", function(window, pane)
	local cwd = get_cwd(pane)
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { "/opt/homebrew/bin/lazygit" },
			cwd = cwd,
			set_environment_variables = {
				PATH = os.getenv("PATH") .. ":/usr/local/bin:/opt/homebrew/bin",
			},
		}),
		pane
	)
end)

return config