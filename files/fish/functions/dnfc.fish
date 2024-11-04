function dnfc --wraps='sudo dnf clean all' --description 'alias dnfc sudo dnf clean all'
  sudo dnf clean all $argv
        
end
