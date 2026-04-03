# My dotfiles

## Requirements

Install [Homebrew](https://brew.sh/):

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install git and stow:

    brew install git stow

Set fish as your login shell:

    brew install fish
    echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
    chsh -s /opt/homebrew/bin/fish

## Install

Clone this repo:

    git clone git@github.com:vdmgolub/dotfiles.git ~/dotfiles

Stow the packages you want:

    cd ~/dotfiles
    stow -t ~ git ag wezterm fish tmux aerospace lazygit starship

Each package creates symlinks in `~` mirroring its directory structure.

## Packages

| Package    | Target                        |
|------------|-------------------------------|
| git        | `~/.gitconfig`, `~/.githelpers`, `~/.gitignore` |
| ag         | `~/.agignore`                 |
| wezterm    | `~/.wezterm.lua`              |
| fish       | `~/.config/fish/`             |
| tmux       | `~/.config/tmux/tmux.conf`    |
| aerospace  | `~/.config/aerospace/`        |
| lazygit    | `~/.config/lazygit/`          |
| starship   | `~/.config/starship.toml`     |

## Notes

- `fish/.config/fish/secrets.fish` is gitignored — create it locally for secrets (e.g. `ANTHROPIC_API_KEY`)
- tmux plugins are managed by [tpm](https://github.com/tmux-plugins/tpm) and not committed; after stowing, run `prefix + I` to install them
- nvim lives at `~/.config/nvim/` with its own git repo