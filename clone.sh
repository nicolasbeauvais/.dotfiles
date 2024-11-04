#!/bin/sh

printf "\e[0;92m==== Cloning dotfiles ====\e[0m\n"

git clone https://github.com/nicolasbeauvais/.dotfiles.git ~/.dotfiles

# ---

print "\n\e[0;92m==== Installation ====\e[0m\n"

bash ~/.dotfiles/install.sh
