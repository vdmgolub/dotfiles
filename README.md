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

## Dependencies

All installed formulae, casks, and Mac App Store apps are listed in [`Brewfile`](./Brewfile). To restore everything on a new machine:

    brew bundle install

Key tools configured by these dotfiles:

| Tool | Description | Uses |
|------|-------------|------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager | |
| [WezTerm](https://wezfurlong.org/wezterm/) | Terminal emulator | `zoxide` |
| [fish](https://fishshell.com/) | Shell | |
| [Tide](https://github.com/IlanCosman/tide) | Shell prompt (fish plugin) | Fisher |
| [fzf.fish](https://github.com/PatrickF1/fzf.fish) | Fuzzy search keybindings (fish plugin) | Fisher, `fzf` |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI | |
| [Neovim](https://neovim.io/) | Editor (separate repo at `~/.config/nvim/`) | |
| [ag](https://github.com/ggreer/the_silver_searcher) | Code search | |

## Install

Clone this repo:

    git clone git@github.com:vdmgolub/dotfiles.git ~/dotfiles

Stow the packages you want:

    cd ~/dotfiles
    stow -t ~ git ag wezterm fish aerospace lazygit

Each package creates symlinks in `~` mirroring its directory structure.

Install [Fisher](https://github.com/jorgebucaran/fisher) and fish plugins (requires the `fish` package to be stowed first):

    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher update

## Packages

| Package    | Target                        |
|------------|-------------------------------|
| git        | `~/.gitconfig`, `~/.githelpers`, `~/.gitignore` |
| ag         | `~/.agignore`                 |
| wezterm    | `~/.wezterm.lua`              |
| fish       | `~/.config/fish/`             |
| aerospace  | `~/.config/aerospace/`        |
| lazygit    | `~/.config/lazygit/`          |

## Notes

- `fish/.config/fish/secrets.fish` is gitignored — create it locally for secrets (e.g. `ANTHROPIC_API_KEY`)
- `archived/` contains configs kept for reference but not actively stowed (e.g. tmux — replaced by wezterm for multiplexing)
- nvim lives at `~/.config/nvim/` with its own git repo