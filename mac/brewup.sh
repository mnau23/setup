#!/bin/bash

TEXTCOLOR='\033[1;34m'

# Update
printf "${TEXTCOLOR}Updating homebrew and local base of packages and versions...\n"
brew update

# Install new versions
printf "${TEXTCOLOR}Upgrading outdated packages...\n"
brew upgrade

# Cleanup
printf "${TEXTCOLOR}Cleaning cache...\n"
brew cleanup

# Upgrade casks
printf "${TEXTCOLOR}Upgrading casks...\n"
brew upgrade --cask --greedy

# Check
printf "${TEXTCOLOR}Checking for problems...\n"
brew doctor

# Upgrade pip
printf "${TEXTCOLOR}Upgrading pip...\n"
python3  -m pip install --upgrade pip

printf "${TEXTCOLOR}Done!\n"
