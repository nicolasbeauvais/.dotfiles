function dnfU --wraps='sudo dnf upgrade' --description 'alias dnfU sudo dnf upgrade'
  sudo dnf upgrade $argv
        
end
