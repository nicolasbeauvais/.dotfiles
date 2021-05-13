#
# Install and setup Doom Emacs
#
git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME/.emacs.d"

ln -s "$HOME/.dotfiles/editors/.doom.d" "$HOME/.doom.d"

"$HOME/.emacs.d/bin/doom install"
