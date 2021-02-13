# Defined in - @ line 1
function pyl --wraps='py local' --wraps=toggle_local_py_env --description 'alias pyl=toggle_local_py_env'
  toggle_local_py_env  $argv;
end
