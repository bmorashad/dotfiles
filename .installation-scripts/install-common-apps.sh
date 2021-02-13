#!/bin/bash

BOLD='\033[1m'
RED='\033[0;31m'
NC='\033[0m' # No Color

sudo eopkg instal inkscape gimp vorta dia filezilla insomnia handbrake knotes mailspring mpv mongodb-compass docker mongodb xournalpp shotcut pdfsam vlc etcher vscode telegram uget gnome-tweaks simplescreenrecorder peek obs-studio mypaint openshot-qt meld terminator vivaldi-stable qbittorrent pdfarranger flameshot

# Solus Official ThirdParty
echo "This might take some time..."

# Anydesk
echo "Installing Anydesk..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/util/anydesk/pspec.xml
sudo eopkg it anydesk*.eopkg;sudo rm anydesk*.eopkg

# Google-Chrome
echo "Installing Google-Chrome..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml
sudo eopkg it google-chrome-*.eopkg;sudo rm google-chrome-*.eopkg

# Datagrip
echo "Installing Datagrip..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/programming/datagrip/pspec.xml
sudo eopkg it datagrip*.eopkg;sudo rm datagrip*.eopkg

# Git Karene
echo "Installing Git-Karen..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/programming/gitkraken/pspec.xml
sudo eopkg it gitkraken*.eopkg;sudo rm gitkraken*.eopkg

# IntelliJ - IDEA
echo "Installing IntelliJ-IDEA..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/programming/idea/pspec.xml
sudo eopkg it idea*.eopkg;sudo rm idea*.eopkg

# Pycharm
echo "Installing Pycharm..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/programming/pycharm/pspec.xml
sudo eopkg it pycharm*.eopkg;sudo rm pycharm*.eopkg

# Microsoft Core Fonts
echo "Installing Microsoft Core Fonts..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/desktop/font/mscorefonts/pspec.xml
sudo eopkg it mscorefonts*.eopkg;sudo rm mscorefonts*.eopkg

# Skype
echo "Installing Skype..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/im/skype/pspec.xml
sudo eopkg it skype*.eopkg;sudo rm *.eopkg

# Pixeluvo: Simple Image Editor...
echo "Installing Pixeluvo..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/multimedia/graphics/pixeluvo/pspec.xml
sudo eopkg it pixeluvo*.eopkg;sudo rm pixeluvo*.eopkg

# Slack
echo "Installing Slack..."
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/im/slack-desktop/pspec.xml
sudo eopkg it slack-desktop*.eopkg;sudo rm slack-desktop*.eopkg

# Snaps

# Postman
sudo snap install postman

# Flatpack

# Popicle: USB Flasher writter in Rust By Pop OS Team
echo "cloning popsicle from https://github.com/pop-os/popsicle..."
git clone git@github.com:pop-os/popsicle.git $GITHUB_APP_DIR/popsicle
echo "installing popsicle in a subshell..."
(cd $GITHUB_APP_DIR/popsicle; make && sudo make install)
echo -e "${RED}${BOLD}NOTE:${NC} make sure popsicle is installed successfully by running popsicle or opening the gui app\n"

echo "tada done :)"
