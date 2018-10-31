#!/bin/bash

# check latest here https://sites.google.com/a/chromium.org/chromedriver/downloads
CHROMEDRIVER_VERSION=2.43

# check latest here https://github.com/mozilla/geckodriver/releases/
GECKODRIVER_VERSION=0.23.0

# check latest here http://phantomjs.org/download.html
PHANTOMJS_VERSION=2.1.1

# paths to install, in case if LOCAL_INSTALL, you need to have these paths
# in your $PATH
if [ "$LOCAL_INSTALL" = "true" ]; then
  BIN_PATH=${HOME}/.local/bin
  LIB_PATH=${HOME}/.local/lib
  mkdir -p $BIN_PATH $LIB_PATH
else
  BIN_PATH=/usr/local/bin
  LIB_PATH=/usr/local/lib
fi

###

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Logger: $1 ${NC}"
}

base_requirements() {
  logger "Installing base requirements..."
  sudo apt install -q -y unzip wget tar
}

chromedriver_install() {
  logger "Installing ChromeDriver..."
  cd /tmp
  wget https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
  sudo rm -f ${BIN_PATH}/chromedriver

  if [ "$LOCAL_INSTALL" = "true" ]; then
    unzip chromedriver_linux64.zip -d $BIN_PATH
  else
    sudo unzip chromedriver_linux64.zip -d $BIN_PATH
  fi

  logger "ChromeDriver executable has been successfully installed to ${BIN_PATH}"
  rm -f chromedriver_linux64.zip
}

geckodriver_install() {
  logger "Installing GeckoDrover..."
  cd /tmp
  wget https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz
  sudo rm -f ${BIN_PATH}/geckodriver

  if [ "$LOCAL_INSTALL" = "true" ]; then
    tar -xvzf geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz -C $BIN_PATH
  else
    sudo tar -xvzf geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz -C $BIN_PATH
  fi

  logger "GeckoDrover executable has been successfully installed to ${BIN_PATH}"
  rm -f geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz
}

browsers_install() {
  logger "Installing browsers..."
  sudo apt install -q -y chromium-browser firefox
  logger "Browsers successfully installed"
}

xvfb_install() {
  logger "Installing xvfb (virtual display)..."
  sudo apt install -q -y xvfb
}

phantomjs_install() {
  logger "Installing phantomJS..."

  # Dependencies for phantomJS
  sudo apt install -q -y chrpath libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev

  # Installing phantomJS
  cd /tmp
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2
  tar -xvjf phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2

  if [ "$LOCAL_INSTALL" = "true" ]; then
    mv phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 $LIB_PATH
    ln -s ${LIB_PATH}/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs $BIN_PATH
  else
    sudo mv phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 $LIB_PATH
    sudo ln -s ${LIB_PATH}/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs $BIN_PATH
  fi

  logger "PhantomJS has been successfully installed and executable avaiable in ${BIN_PATH}"
  rm -rf phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2
}


main() {
  base_requirements
  chromedriver_install
  geckodriver_install
  browsers_install
  xvfb_install
  phantomjs_install
}

main
