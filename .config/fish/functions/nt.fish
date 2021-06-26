# Defined in - @ line 1
function nt --wraps=notes --wraps='notes new' --wraps=notes_tag_fzf --wraps=notes_hashtag_fzf --description 'alias nt=notes_hashtag_fzf'
  notes_hashtag_fzf  $argv;
end
