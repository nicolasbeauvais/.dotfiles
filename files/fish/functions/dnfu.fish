function dnfu --wraps='sudo dnf update' --description 'alias dnfu sudo dnf update'
  sudo dnf update $argv
        
end
