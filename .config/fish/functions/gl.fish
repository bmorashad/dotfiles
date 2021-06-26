# Defined in - @ line 1
function gl --wraps=git_commits_with_fzf --description 'alias gl=git_commits_with_fzf'
  git_commits_with_fzf  $argv;
end
