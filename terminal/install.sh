#
# Install and setup Prezto
#
git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

for rcfile in "$HOME"/.dotfiles/terminal/prezto/runcoms/*(.); do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
done

for module in "$HOME"/.dotfiles/terminal/prezto/modules/*; do
    ln -s "$module" "$HOME/.zprezto/modules/${module:t}"
done

# Set Zsh as default shell
chsh -s $(which zsh)
