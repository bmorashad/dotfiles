function gdn --wraps='git diff --name-only ' --description 'alias gdn=git diff --name-only '
  git diff --name-only  $argv; 
end
