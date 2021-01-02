#!/bin/bash

# Intializing Thirparty-Apps repo folder
echo "creating ~/.thirdparty-app dir"
mkdir -p ~/.thirdparty-app

# ThirdParty - GitHub
echo "creating ~/.thridparty-apps/github dir"
mkdir -p ~/.thirdparty-app/github/

# add path to .bashrc
echo "exporting thridparty dir and github dir to bash_profile..."
echo "export THIRDPARTY_APP_DIR=~/.thirdparty-app" >> ~/.bash_profile
echo "export GITHUB_APP_DIR=$THIRDPARTY_APP_DIR/github" >> ~/.bash_profile
echo "sourcing .bash_profile..."
source ~/.bash_profile

echo "creating ~/.py_env/py_env3"
mkdir -p ~/.py_env/py_env3
echo "make python3 virtual env"
virtualenv python3 ~/.py_env/py_env3

echo "exporting python env to bash_profile..."
echo "export PYTHON_ENV=~/.py_env" >> ~/.bash_profile
echo "export PYTHON_ENV3=$PYTHON_ENV/py_env3" >> ~/.bash_profile
echo "sourcing .bash_profile..."

echo "====pre-install-status: done :)===="

