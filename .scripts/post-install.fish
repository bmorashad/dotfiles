# /bin/bash

sudo eopkg install \ 
fd ripgrep autokey-py3 fish rush go cargo htop bat exa alacritty tmux tdrop xdotool fzf neovim tealdeer broot
# install rust tools not in eopkg
cargo install git-delta dust procs zoxide
# install my cli notes app
GO111MODULE=on go get -u github.com/rhysd/notes-cli/cmd/notes
# install fisher plugin manager for fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# install nvm for fish (not the mainstream)
fisher add jorgebucaran/nvm.fish
# install bass - bash script(command) execution from fish
fisher add edc/bass
