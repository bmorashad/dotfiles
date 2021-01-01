# /bin/bash

sudo eopkg install \ 
fd ripgrep autokey-py3 fish rush go cargo htop bat exa alacritty tmux tdrop xdotool fzf neovim tealdeer broot \
glow borg virtualenv
# install rust tools not in eopkg
cargo install git-delta dust procs zoxide
# install my cli notes app
GO111MODULE=on go get -u github.com/rhysd/notes-cli/cmd/notes
# install fisher plugin manager for fish
# https://github.com/jorgebucaran/fisher
# old command
# curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
# install nvm for fish (not the mainstream)
fisher add jorgebucaran/nvm.fish
# install bass: bash script(command) execution from fish
fisher add edc/bass
# source new changes to fish shell
source ~/.config/fish/config.fish
# vim-plug: plugin manager for vim
# https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# jenv: java version manager
git clone https://github.com/jenv/jenv.git ~/thirdparty-apps/github.jenv
# add to bash (to work properly with fish)
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(jenv init -)"' >> ~/.bash_profile
# RESTART SHELL
exec $SHELL -l
# add to fish
# echo 'set PATH $HOME/.jenv/bin $PATH' >> ~/.config/fish/config.fish ALREADY EXIST
# echo 'status --is-interactive; and source (jenv init -|psub)' >> ~/.config/fish/config.fish ALREADY EXIST
jenv enable-plugin export
cp ~/.jenv/fish/jenv.fish ~/.config/fish/functions/jenv.fish
cp ~/.jenv/fish/export.fish ~/.config/fish/functions/export.fish
# add java paths to jenv
echo "run jenv add /opt/jdk-11<version> after installing jdk 11"
echo "run jenv add /opt/jdk-8<version> after installing jdk 8"
# test if jenv successfull
jenv doctor
# RESTART SHELL
exec $SHELL -l

# install neovim plugins
echo "opening neovim and running PlugInstall..."
neovim +PlugInstall +qa
