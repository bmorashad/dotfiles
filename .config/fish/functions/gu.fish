# Defined in - @ line 1
function gu --wraps='git add -u' --description 'alias gu=git add -u'
  git add -u $argv;
end
