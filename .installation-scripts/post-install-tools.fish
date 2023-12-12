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
echo (source $PYTHON_ENV3_DIR/bin/activate.fish && pip install neovim pynvim && deactivate)
echo "make python2 virtual env"
virtualenv -p python2 $PYTHON_ENV2_DIR
echo (source $PYTHON_ENV2_DIR/bin/activate.fish && pip install neovim pynvim && deactivate)

# NOTE: Replace virtualenv with Pyenv setup gracefully
# Removing virtualenv fully ATM is a problem since pyenv deactivate function doesn't undo the prompt change
# Hence must depend on virtualenv deactivate function for that
# See notes at config.fish
echo "Installing pyenv"
curl https://pyenv.run | bash
pyenv init - | source
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv install 3.8
pyenv global 3.8
pyenv version
pyenv virtualenv 3.8 py3_env
# pyenv deactivate


# add docker auto completion to fish
mkdir -p ~/.config/fish/completions
wget https://raw.github.com/docker/cli/master/contrib/completion/fish/docker.fish -O ~/.config/fish/completions/docker.fish

# source new changes to fish shell
echo "source new changes to fish shell"
source ~/.config/fish/config.fish
