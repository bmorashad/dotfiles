# Defined in - @ line 1
function c --wraps=clear --wraps='clear ; fish_greeting' --description 'alias c=clear; fish_greeting'
  clear ; fish_greeting $argv;
end
