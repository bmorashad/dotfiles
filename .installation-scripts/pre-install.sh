#!/bin/bash

# Intializing Thirparty-Apps repo folder
echo "creating ~/.thirdparty-app dir"
mkdir -p ~/.thirdparty-app

# ThirdParty - GitHub
echo "creating ~/.thridparty-apps/github dir"
mkdir -p ~/.thirdparty-app/github/

# NOTE: Solus uses .profile by default
# reference: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
# After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable

THIRDPARTY_APP_DIR="~/.thirdparty-app"
GITHUB_APP_DIR="$THIRDPARTY_APP_DIR/github"

PYTHON_ENV_DIR="$HOME/.py_env"
PYTHON_ENV3_DIR="$PYTHON_ENV_DIR/py_env3"
PYTHON_ENV2_DIR="$PYTHON_ENV_DIR/py_env2"


# add path to .profile
echo "exporting thridparty dir and github dir to .profile..."
echo "export THIRDPARTY_APP_DIR=$THIRDPARTY_APP_DIR" >> ~/.profile
echo "export GITHUB_APP_DIR=$GITHUB_APP_DIR" >> ~/.profile
echo "sourcing .profile..."
source ~/.profile

# Intializing local python evnironemnt
echo "creating ~/.py_env/py_env3"
mkdir -p ~/.py_env/py_env3

echo "exporting python env dir to .profile..."
echo "export PYTHON_ENV_DIR=$PYTHON_ENV_DIR >> ~/.profile"
echo "export PYTHON_ENV3_DIR=$PYTHON_ENV3_DIR" >> ~/.profile
echo "export PYTHON_ENV2_DIR=$PYTHON_ENV2_DIR" >> ~/.profile

echo "====pre-install-status: done :)===="
