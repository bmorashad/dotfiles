# /bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Solus Repo
sudo eopkg install \ 
fd ripgrep autokey-py3 fish rush go cargo htop bat exa alacritty tmux tdrop xdotool fzf neovim tealdeer broot \
glow borg virtualenv rofi

# Rust
echo "installing cli tools written in rust"
cargo install git-delta dust procs zoxide

echo "cloning sad for sed (https://github.com/ms-jpq/sad)"
git clone https://github.com/ms-jpq/sad $GITHUB_APP_DIR/sad
echo "installing sad in a subshell"
(cd $GITHUB_APP_DIR/sad && cargo install --locked --all-features --path .)
echo -e "${RED}${BOLD}NOTE:${NC} make sure sad installation is successfull by running sad\n"

# Golang
# install my cli notes app
echo "installing my cli notes app..."
GO111MODULE=on go get -u github.com/rhysd/notes-cli/cmd/notes


# vim-plug: plugin manager for vim
# https://github.com/junegunn/vim-plug
echo "\ninstalling vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# jenv: java version manager
# this needs to be installed both on fish and bash inorder to work on fish
echo "\ninstalling jenv..."
git clone https://github.com/jenv/jenv.git ~/.jenv
# add to bash (to work properly with fish)

# NOTE: Solus uses .profile by default
# reference: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
# After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable

# echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
# echo 'eval "$(jenv init -)"' >> ~/.bash_profile
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(jenv init -)"' >> ~/.profile
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
