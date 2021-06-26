# Defined in - @ line 1
function sbrc --wraps='bass source ~/.bashrc' --description 'alias sbrc=bass source ~/.bashrc'
  bass source ~/.bashrc $argv;
end
