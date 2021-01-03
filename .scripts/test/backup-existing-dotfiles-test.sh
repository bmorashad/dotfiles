#!/bin/bash
echo 'error: The following untracked working tree files would be overwritten by checkout:
  .bashrc
  .gitignore
  .config/nvim/init.vim
Please move or remove them before you can switch branches
Aborting' | egrep '\s+\.' | awk {'print $1'} | \
	while read dotfile; do
		echo 'creating directory for '$dotfile'...'
		dir=$(dirname $dotfile)
		mkdir -p ''$HOME'/.config-backup/'$dir''
		mv $HOME/$dotfile $HOME/.config-backup/$dir
	done
