# Defined in - @ line 1
function tse --wraps=tmux_create_session --description 'alias tse=tmux_create_session'
  tmux_create_session  $argv;
end
