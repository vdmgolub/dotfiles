# My dotfiles

## Requirements

Install [homebrew](http://brew.sh/)
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

Install git:

    brew install git

Install [prezto](https://github.com/sorin-ionescu/prezto)

    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

Set zsh as your login shell.

    chsh -s /bin/zsh

## Install

Clone this repo:

    git clone git://github.com/vdmgolub/dotfiles.git ~/.dotfiles

Run `brew bundle` to install `rcm` and other apps:

    brew bundle ~/.dotfiles

Install:

    rcup -x README.md -x Brewfile

Rcup will create symlinks for all files of `~./dotfiles` in home directory excluding
those marked with `-x`.
