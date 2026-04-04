# Disable the default greeting message on shell start
set -g fish_greeting
# Root directory for work projects — used to load per-project .fish_local configs
set -g WORK_DIR "$HOME/work"

# Universal environment variables (persistent across sessions)
set -Ux TZ UTC
set -Ux EDITOR nvim
set -Ux TMUX_PLUGIN_MANAGER_PATH ~/.tmux/plugins/tpm/
set -Ux PSQL_PAGER "pspg -X -b"

# Configure fzf keybindings — only in interactive shells
if status is-interactive
    fzf_configure_bindings --directory=\ct
end

# Load secrets (API keys etc.) — file is gitignored, create locally
if test -e $HOME/.config/fish/secrets.fish
  source $HOME/.config/fish/secrets.fish
end

# Load per-project fish configs from $WORK_DIR/*/.fish_local (not tracked in dotfiles)
for f in $WORK_DIR/*/.fish_local
  source $f
end

# Add local binaries to PATH before mise so mise-managed tools take precedence
set -gx PATH "$HOME/.local/bin" $PATH

# Initialize mise (language version manager) — must run after PATH modifications
mise activate fish | source

# Wrapper for yazi file manager that changes the shell's cwd on exit
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Initialize zoxide (smarter cd)
zoxide init fish | source