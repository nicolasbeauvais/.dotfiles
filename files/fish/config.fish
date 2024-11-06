if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source

set PATH /usr/local/{bin,sbin} $PATH
set PATH ~/.local/bin $PATH
set PATH ~/.node_modules/bin $PATH
set PATH ~/.config/composer/vendor/bin $PATH
set PATH ~/.local/share/JetBrains/Toolbox/scripts $PATH
set PATH /snap/bin $PATH

# Pyenv
pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

