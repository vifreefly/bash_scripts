#!/bin/bash

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Installer:${NC}"
}

basic_install() {
  echo "$(logger) Update system..."
  sudo apt -y update

  echo "$(logger) Install basic utils..."
  sudo apt install -q -y git wget curl tar zip unzip file tree htop ssh gnupg build-essential bash-completion net-tools dpkg python-software-properties
}

set_local_bin_path() {
  echo "$(logger) Creating a local bin path (~/.local/bin) folder and adding it to the $PATH"
  mkdir -p ~/.local/bin ~/.local/lib

  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  echo "$(logger) exported local bin path variable to ~/.bashrc"
}

configure_locale() {
  echo "$(logger) Configuring en_US.UTF-8 locale..."
  sudo locale-gen en_US.UTF-8

  # Add locale env variables to ~/.bashrc
  echo 'export LANG="en_US.UTF-8"' >> ~/.bashrc
  echo 'export LANGUAGE="en_US:en"' >> ~/.bashrc
  echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc
  echo "$(logger) exported locale variables to ~/.bashrc"
}

# to do add time zone configure (set to UTC always)
# UTC it's a default time and should be by default on any server

# Modern XXI centry CLI text editor https://github.com/zyedidia/micro
# It should be on any linux server by default
micro_install() {
  echo "$(logger) Installing Micro editor..."
  # delete old version first (if it's already exists)
  cd /usr/local/bin && sudo rm -f micro
  sudo curl https://getmic.ro | sudo bash

  # make micro a default cli editor, by including env variable EDITOR to the ~/.bashrc
  echo 'export EDITOR="micro"' >> ~/.bashrc
  echo "$(logger) exported env variable EDITOR=micro to ~/.bashrc"
}

main() {
  basic_install
  set_local_bin_path
  configure_locale
  micro_install
}

main
