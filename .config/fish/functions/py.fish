# Defined in /home/bmora/.config/fish/functions/py.fish @ line 2
function py
  if count $argv > /dev/null 
	  set -l env $argv[1]
	  # Great... fish first array index is ... 1 !
	  if test "$env" = "local"
		  activate_local_py_env3
	  else if test "$env" = "system"
		  deactivate_local_py_env3
	  end
  end
end
