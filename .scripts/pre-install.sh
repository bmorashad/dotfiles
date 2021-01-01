#!/bin/bash

# Intializing Thirparty-Apps repo folder
echo "creating ~/.thirdparty-app dir"
mkdir -p ~/.thirdparty-app

# ThirdParty - GitHub
echo "creating ~/.thridparty-apps/github dir"
mkdir -p ~/.thirdparty-app/github/

# add path to .bashrc
echo "exporting thridparty dir and github dir to bashrc..."
echo 'export THIRDPARTY_APP_DIR='~/.thirdparty-app'' >> ~/.bashrc
echo 'export GITHUB_APP_DIR='$THIRDPARTY_APP_DIR/github'' >> ~/.bashrc
echo 'export THIRDPARTY_APP_DIR='~/.thirdparty-app'' >> ~/.bash_profile
echo 'export GITHUB_APP_DIR='$THIRDPARTY_APP_DIR/github'' >> ~/.bash_profile
echo "sourcing .bashrc..."
source ~/.bashrc
echo "====pre-install-status: done :)===="
