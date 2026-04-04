set -g fish_greeting

set -Ux TZ UTC
set -Ux EDITOR nvim
set -Ux TMUX_PLUGIN_MANAGER_PATH ~/.tmux/plugins/tpm/
set -Ux PSQL_PAGER "pspg -X -b"

if status is-interactive
    fzf_configure_bindings --directory=\ct
end

# Source secrets file if it exists
if test -e $HOME/.config/fish/secrets.fish
  source $HOME/.config/fish/secrets.fish
end

mise activate fish | source

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

alias fml='npm run format; npm run test:eslint-rules --; npm run lint -- --ignore-pattern "src/scripts/vadim/**";'

export PATH="$HOME/.local/bin:$PATH"

zoxide init fish | source
