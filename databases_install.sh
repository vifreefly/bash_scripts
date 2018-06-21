#!/bin/bash

# For postgres, mysql or mongodb sometimes you don't need to install server, only client
# (in case if your database server located on other remote server, and you just want to
# connect to this server).
# So if you want to install only client, provide env variable INSTALL_CLIENT_ONLY=true and
# call the script this way `$ INSTALL_CLIENT_ONLY=true bash databases_install.sh database_type_install`

# also see https://gorails.com/setup/ubuntu/16.04

# Note: for mysql and postgres server you need to make an additional steps to setup
# configuration and create database user

# check latest here https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
MONGO_DB_VERSION="3.6"

###

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Installer:${NC}"
}

sqlite3_install() {
  echo "$(logger) Installing sqlite3..."
  sudo apt -q -y install libsqlite3-dev sqlite3

  echo "$(logger) Successfully installed sqlite3"
}

mysql_install() {
  echo "$(logger) Installing mysql..."

  if [ "$INSTALL_CLIENT_ONLY" = "true" ]; then
    sudo apt -q -y install mysql-client libmysqlclient-dev
    echo "$(logger) Successfully installed mysql client"
  else
    sudo apt -q -y install mysql-server mysql-client libmysqlclient-dev
    echo "$(logger) Successfully installed mysql client and mysql server"
  fi
}

postgres_install() {
  echo "$(logger) Installing postgres..."

  if [ "$INSTALL_CLIENT_ONLY" = "true" ]; then
    sudo apt install -q -y postgresql-client libpq-dev
    echo "$(logger) Successfully installed postgres client"
  else
    sudo apt install -q -y postgresql postgresql-contrib libpq-dev
    echo "$(logger) Successfully installed postgres client and server"
  fi
}

mongodb_install() {
  # also see https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

  echo "$(logger) Installing mongodb..."
  if [ "$INSTALL_CLIENT_ONLY" = "true" ]; then
    sudo apt install -q -y mongodb-clients
    echo "$(logger) Successfully installed mongodb client"
  else
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/${MONGO_DB_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_DB_VERSION}.list
    sudo apt update
    sudo apt-get install -q -y mongodb-org
    echo "$(logger) Successfully installed mongodb server"

    sudo service mongod start
    echo "$(logger) Successfully started mongodb server"
  fi
}

main() {
  sqlite3_install
  mysql_install
  postgres_install
  mongodb_install
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
