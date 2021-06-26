# Defined in - @ line 1
function lsl --wraps='ls -l' --description 'alias lsl=ls -l'
  ls -l $argv;
end
