#!/bin/sh

HOSTNAME=ghost

sh "$HOME/.dotfiles/install/01_system.sh"
sh "$HOME/.dotfiles/install/02_packages.sh"
sh "$HOME/.dotfiles/install/03_services.sh"

(zsh "$HOME/.dotfiles/editors/install.sh")
(zsh "$HOME/.dotfiles/keyboard/install.sh")
(zsh "$HOME/.dotfiles/terminal/install.sh")
(zsh "$HOME/.dotfiles/backup/install.sh")

# Cleanup
rm -f "$HOME/.bash_history" \
   "$HOME/.bash_logout" \
   "$HOME/.bash_profile" \
   "$HOME/.bashrc" \
   "$HOME/clone.sh"
