# /bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
NC='\033[0m' # No Color
echo "installing dev tools"
sudo eopkg install -c system.devel
# Solus Repo
sudo eopkg install alsa-tools starship nnn fd ripgrep autokey-py3 fish rust golang cargo htop bat exa alacritty tmux tdrop xdotool fzf neovim tealdeer broot glow borg virtualenv rofi pipenv xev openssh-server rsync nmap httpie inxi

# Rust
echo "${BOLD}Installing cli tools written in rust${NC}"
cargo install git-delta du-dust procs zoxide

echo "${BOLD}Cloning sad for sed (https://github.com/ms-jpq/sad)${NC}"
git clone https://github.com/ms-jpq/sad $GITHUB_APP_DIR/sad
echo "${BOLD}Installing sad in a subshell${NC}"
(cd $GITHUB_APP_DIR/sad && cargo install --locked --all-features --path .)
echo -e "${RED}${BOLD}NOTE:${NC} make sure sad installation is successfull by running sad"

# Golang
# install my cli notes app
echo "${BOLD}Installing my cli notes app...${NC}"
GO111MODULE=on go get -u github.com/rhysd/notes-cli/cmd/notes


# vim-plug: plugin manager for vim
# https://github.com/junegunn/vim-plug
echo "${BOLD}Installing vim-plug...${NC}"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# NOTE: Solus uses .profile by default
# reference: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
# After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable

# install neovim plugins
echo "opening neovim and running PlugInstall..."
neovim +PlugInstall +qa

echo "tada done :)"
