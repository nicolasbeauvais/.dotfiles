#!/bin/sh

HOSTNAME=ghost

sh ./scripts/01_system.sh
sh ./scripts/02_packages.sh

zsh ./editors/install.sh
zsh ./keyboard/install.sh
zsh ./terminal/install.sh
zsh ./backup/install.sh
