# My dotfiles

## Requirements

Install [prezto](https://github.com/sorin-ionescu/prezto)

    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

Set zsh as your login shell.

    chsh -s /bin/zsh

Install [rcm](https://github.com/mike-burns/rcm).

    brew tap mike-burns/rcm
    brew install rcm

Install
-------

Clone this repo:

    git clone git://github.com/vdmgolub/dotfiles.git ~/.dotfiles

Install:

    rcup -x README.md

Rcup will create symlinks for all files of `~./dotfiles` in home directory excluding
those marked with `-x`.
