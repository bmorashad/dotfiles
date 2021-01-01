#!/bin/bash

echo 'making .config-backup directory...' && \
mkdir -p ''$HOME'/.config-backup' && config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
	while read dotfile; do
		echo 'creating directory for '$dotfile'...'
		dir=$(dirname $dotfile)
		mkdir -p ''$HOME'/.config-backup/'$dir''
		mv $HOME/$dotfile $HOME/.config-backup/$dir
	done
