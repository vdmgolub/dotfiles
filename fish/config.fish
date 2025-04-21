set -g fish_greeting

set -Ux TZ UTC
set -Ux EDITOR nvim
set -Ux TMUX_PLUGIN_MANAGER_PATH ~/.tmux/plugins/tpm/

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Source secrets file if it exists
if test -e $HOME/.config/fish/secrets.fish
  source $HOME/.config/fish/secrets.fish
end
