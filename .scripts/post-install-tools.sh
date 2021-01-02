# /bin/bash

# Solus Repo
sudo eopkg install \ 
fd ripgrep autokey-py3 fish rush go cargo htop bat exa alacritty tmux tdrop xdotool fzf neovim tealdeer broot \
glow borg virtualenv

# Rust
cargo install git-delta dust procs zoxide
cargo install --locked --all-features --path $GITHUB_APP_DIR

# Golang
# install my cli notes app
GO111MODULE=on go get -u github.com/rhysd/notes-cli/cmd/notes


# vim-plug: plugin manager for vim
# https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# jenv: java version manager
# this needs to be installed both on fish and bash inorder to work on fish
git clone https://github.com/jenv/jenv.git ~/.jenv
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
# test if jenv successfull
jenv doctor
echo "if anything went wrong refer: https://github.com/jenv/jenv"
# RESTART SHELL
exec $SHELL -l

# install neovim plugins
echo "opening neovim and running PlugInstall..."
neovim +PlugInstall +qa

echo "tada done :)"
