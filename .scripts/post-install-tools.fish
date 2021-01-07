#!/usr/bin/fish

# install fisher plugin manager for fish
# https://github.com/jorgebucaran/fisher
# old command
# curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# new command
echo "installing fisher plugin manager (https://github.com/jorgebucaran/fisher) for fish "
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# installing forgit: git with fzf 
echo "installing forgit: git with fzf <https://github.com/wfxr/forgit>" 
fisher install wfxr/forgit

# install nvm for fish (not the mainstream)
echo "install nvm (https://github.com/jorgebucaran/nvm.fish) for fish "
fisher install jorgebucaran/nvm.fish

# source new changes to fish shell
echo "source new changes to fish shell"
source ~/.config/fish/config.fish

echo "installing node 12 latest..."
nvm install 12
echo "installing node 14 latest..."
nvm install 14
echo "making node 14 the global default"
set --universal nvm_default_version v14

# install bass: bash script(command) execution from fish
echo "installing bass - bash commands in fish..."
fisher install edc/bass

echo "make python3 virtual env"
virtualenv -p python3 $PYTHON_ENV3_DIR
(source $PYTHON_ENV3_DIR/bin/activate && pip install neovim pynvim && deactivate)
echo "make python2 virtual env"
virtualenv -p python2 $PYTHON_ENV2_DIR
(source $PYTHON_ENV2_DIR/bin/activate && pip install neovim pynvim && deactivate)

# source new changes to fish shell
echo "source new changes to fish shell"
source ~/.config/fish/config.fish
