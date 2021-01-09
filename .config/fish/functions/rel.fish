# Defined in - @ line 1
function reload --wraps=reload_shell --description 'alias reload=reload_shell'
  reload_shell  $argv;
end
