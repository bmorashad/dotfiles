# Defined in - @ line 1
function config --wraps='/usr/bin/git --git-dir=/home/bmora/dotfiles/ --work-tree=/home/bmora/' --description 'alias config=/usr/bin/git --git-dir=/home/bmora/dotfiles/ --work-tree=/home/bmora/'
  /usr/bin/git --git-dir=/home/bmora/dotfiles/ --work-tree=/home/bmora/ $argv;
end
