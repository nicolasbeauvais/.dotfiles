#
# Install and setup Prezto
#
git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

# Install Prezto contrib
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/belak/prezto-contrib "$HOME/.zprezto/contrib"

for rcfile in "$HOME/.dotfiles/terminal/prezto/runcoms/*(.)"; do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
done

for module in "$HOME/.dotfiles/terminal/prezto/modules/*"; do
    ln -s "$module" "$HOME/.zprezto/modules/${module:t}"
done

# Remove invalid profile for which2
sudo rm /etc/profile.d/which2.sh

# Set Zsh as default shell
chsh -s $(which zsh)

# Setup Kitty configuration
ln -s "$HOME/.dotfiles/terminal/kitty" "$HOME/.config/kitty"
