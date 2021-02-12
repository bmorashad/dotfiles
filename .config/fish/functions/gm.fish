# Defined in - @ line 1
function gm --wraps='git merge --no-off' --description 'alias gm=git merge --no-off'
  git merge --no-off $argv;
end
