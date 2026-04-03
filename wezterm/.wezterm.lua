-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.front_end = "OpenGL"

config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 19

-- config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- For pi.dev
-- config.enable_kitty_keyboard = true

config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- workspace_switcher.apply_to_config(config)

-- Switch from tmux below

-- Smart splits
local w = require("wezterm")

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
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
		action = w.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
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

local act = wezterm.action

-- If you're using emacs you probably wanna choose a different leader here,
-- since we're gonna be making it a bit harder to CTRL + A for jumping to
-- the start of a line
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- splitting
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "=",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "g",
		mods = "LEADER",
		action = act.EmitEvent("open-lazygit"),
	},

	-- switch to tab by number (like tmux leader+1/2/3)
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	-- {
	-- 	key = "s",
	-- 	mods = "LEADER",
	-- 	action = workspace_switcher.switch_workspace(),
	-- },
	-- {
	-- 	key = "S",
	-- 	mods = "LEADER",
	-- 	action = workspace_switcher.switch_to_prev_workspace(),
	-- },
}

-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config,
--   {
--     position = "top",
--   }
-- )
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		-- icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = "", --wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = "", --wezterm.nerdfonts.pl_left_soft_divider,
			right = "", --wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = "", --wezterm.nerdfonts.pl_left_hard_divider,
			right = "", --wezterm.nerdfonts.pl_right_hard_divider,
		},
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
	-- Custom keybindings (set to nil to disable)
	keybinds = {
		show_picker = { mods = "LEADER", key = "s" },
		create_workspace = { mods = "LEADER", key = "S" },
		rename_workspace = { mods = "LEADER", key = "r" },
	},
})
workspace_picker.apply_to_config(config)

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

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
	},
}

return config
