#!/bin/bash

# To install only specific lang, call the script this way:
# `$ bash extended_install.sh node_js_install`

# check latest here https://golang.org/dl/
GOLANG_VERSION="1.10.3"

# check latest here https://www.ruby-lang.org/en/downloads/releases/
RUBY_VERSION=2.5.1

###

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Logger: $1 ${NC}"
}

### Python ###

python_install() {
  logger "Installing python and pipi..."
  sudo apt install -q -y python python3 python-pip python3-pip
}

### Golang ###

golang_install() {
  logger "Installing golang..."

  cd /tmp && wget https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz
  rm -rf go${GOLANG_VERSION}.linux-amd64.tar.gz
  mkdir -p ~/go

  # add go path env variables to ~/.bashrc
  echo 'export PATH="/usr/local/go/bin:$PATH"' >> ~/.bashrc
  echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
}

### NodeJS ###

node_js_install() {
  ### NodeJS installation ###
  logger "Installing NodeJS using NVM..."
  # install dependencies for node compiling
  sudo apt install -q -y build-essential libssl-dev

  # Install NVM https://github.com/creationix/nvm
  # It will automatically add env variables to ~/.bashrc
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

  # update env variables
  source ~/.bashrc
  # export nvm and node path for further installation
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # install latest stable lts release of node
  nvm install --lts
  logger "NodeJS installed, version: $(node -v)"

  ### Yarn installation ###
  # Install yarn using oficial installation script
  # It will automatically add yarn env variables to ~/.bashrc
  curl -o- -L https://yarnpkg.com/install.sh | bash

  # update env variables
  source ~/.bashrc
  # export yarn path
  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

  # check yarn version
  logger "Yarn installed, version: $(yarn -v)"

  # ToDo: maybe it's a good idea to add alias from node to nodejs (in ubuntu)
}

### Ruby ###
# also see https://gorails.com/setup/ubuntu/16.04

ruby_install() {
  ruby_dependencies_install
  rbenv_install
  ruby_version_install
  bundler_install
}

ruby_dependencies_install() {
  logger "Installing ruby build dependencies..."
  sudo apt install -q -y zlib1g-dev build-essential libssl-dev libreadline-dev libreadline6-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev
}

rbenv_install() {
  logger "Installing rbenv..."

  cd && rm -rf ~/.rbenv
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build


  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc

  # update env variables
  source ~/.bashrc
  # export rbenv path for further ruby installation using rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
}

ruby_version_install() {
  # Install ruby
  logger "Installing ruby ${RUBY_VERSION}..."
  export CONFIGURE_OPTS="--disable-install-doc"
  rbenv install $RUBY_VERSION

  logger "Enabling ruby ${RUBY_VERSION} as global version..."
  rbenv global $RUBY_VERSION

  rbenv rehash
}

bundler_install() {
  ### gems config ###
  # disable downloading gems documentation
  echo "gem: --no-ri --no-rdoc" > ~/.gemrc && chmod 644 ~/.gemrc

  # install bundler
  logger "Installing bundler..."
  rbenv exec gem install bundler

  ### bundler config ###
  # allow to install gems from insecure sources (git)
  rbenv exec bundle config --global git.allow_insecure true
  # enable parrallel gems installation (4 in parallel)
  rbenv exec bundle config --global jobs 4
}

###

main() {
  python_install
  golang_install
  node_js_install
  ruby_install
}

###

if declare -f "$1" > /dev/null; then
  "$@" # call function
else
  read -r -p "You called script without any function name. Would you like a full installation? [y/N] " resp
  if [[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    main
  fi
fi
