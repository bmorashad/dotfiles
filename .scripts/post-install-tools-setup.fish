#!/usr/bin/fish

# install fisher plugin manager for fish
# https://github.com/jorgebucaran/fisher
# old command
# curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# new command
echo "installing fisher plugin manager (https://github.com/jorgebucaran/fisher) for fish "
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

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

echo "creating ~/.py_env/py_env3"
mkdir -p ~/.py_env/py_env3
echo "make python3 virtual env"
virtualenv python3 ~/.py_env/py_env3

echo "exporting python env dir to .profile..."
echo "export PYTHON_ENV=~/.py_env" >> ~/.profile
echo "export PYTHON_ENV3=$PYTHON_ENV/py_env3" >> ~/.profile

# source new changes to fish shell
echo "source new changes to fish shell"
source ~/.config/fish/config.fish
