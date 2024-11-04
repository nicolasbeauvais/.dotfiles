function dnfL --wraps='dnf list installed' --description 'alias dnfL dnf list installed'
  dnf list installed $argv
        
end
