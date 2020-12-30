#!/usr/bin/fish

echo 'making .config-backup directory...' && \
mkdir -p ''$HOME'/.config-backup' && config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
	while read -l dotfile
		echo 'creating directory for '$dotfile'...'
		set -l dir (dirname $dotfile)
		mkdir -p ''$HOME'/.config-backup/'$dir''
	end | \
		xargs -I{} mv {} .config-backup/{}
