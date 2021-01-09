# Defined in - @ line 1
function nt --wraps=notes --wraps='notes new' --wraps=notes_tag_fzf --description 'alias nt=notes_tag_fzf'
  notes_tag_fzf  $argv;
end
