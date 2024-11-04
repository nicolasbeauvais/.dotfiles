function dnfr --wraps='sudo dnf remove' --description 'alias dnfr sudo dnf remove'
  sudo dnf remove $argv
        
end
