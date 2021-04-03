#!/bin/sh

PRIVATE_REPOSITORY=https://nicolasbeauvais@github.com/nicolasbeauvais/.private.git
PUBLIC_REPOSITORY=git@github.com:nicolasbeauvais/.dotfiles.git

git clone "$PRIVATE_REPOSITORY" ~/.private
git clone "PUBLIC_REPOSITORY" ~/.dotfiles

bash ~/.private/install.sh
bash ~/.dotfiles/install.sh
