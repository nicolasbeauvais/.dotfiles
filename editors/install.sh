#
# Install and setup Doom Emacs
#
git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME/.emacs.d"

sh "$HOME/.emacs.d/bin/doom install"

ln -s "$HOME/.dotfiles/editors/.doom.d" "$HOME/.doom.d"

#
# Install and setup PHPStorm
#
wget https://download-cf.jetbrains.com/webide/PhpStorm-2020.3.3.tar.gz
sudo tar -xzf PhpStorm-*.tar.gz -C /opt
rm PhpStorm-*.tar.gz
ln -s /opt/PhpStorm-*/bin/phpstorm.sh /usr/bin/phpstorm

# @TODO: add JVM configuration files
# @TODO: add desktop entry
