#!/bin/sh

printf "\e[0;92m==== Ghost cloning ====\e[0m\n"

PRIVATE_REPOSITORY=https://nicolasbeauvais@github.com/nicolasbeauvais/.private.git
PUBLIC_REPOSITORY=https://github.com/nicolasbeauvais/.dotfiles.git

# ---

echo 'Cloning private dotfiles...'

git clone "$PRIVATE_REPOSITORY" ~/.private

# ---

echo 'Cloning public dotfiles...'

git clone "$PUBLIC_REPOSITORY" ~/.dotfiles

# ---

print "\n\e[0;92m==== Ghost installation ====\e[0m\n"

bash ~/.private/install.sh
bash ~/.dotfiles/install.sh
