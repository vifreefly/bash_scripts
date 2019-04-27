#!/bin/bash

# note: all utils installing to local ~/.local/bin path, so make sure
# that you have this directory in your $PATH (check base_install.sh)

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Logger: $1 ${NC}"
}

github_latest_tag() {
  local tag=$(curl https://github.com/$1/releases/latest -s -L -I -o /dev/null -w '%{url_effective}' | grep -oP '[\d\.]+$')
  echo $tag
}

###

basic_install() {
  logger "Installing basic utils..."
  sudo apt install -q -y editorconfig
}

### tmux ###
tmux_install() {
  logger "Installing latest tmux release..."
  TMUX_VERSION=$(github_latest_tag tmux/tmux)

  sudo apt remove -q -y tmux
  sudo apt install -q -y libevent-dev libncurses-dev gawk checkinstall

  cd /tmp && wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
  tar -xf tmux-${TMUX_VERSION}.tar.gz && rm -f tmux-${TMUX_VERSION}.tar.gz
  cd tmux-${TMUX_VERSION} && ./configure && sudo make
  sudo checkinstall -y --pkgname tmux --pkgversion ${TMUX_VERSION} --nodoc --requires=libevent-dev,libncurses-dev --install=yes
  logger "Tmux was successfully installed, version: $(tmux -V)"

  xpanes_install

  read -r -p "Done. Install clipboard for tmux and other command-line tools? [y/N] " resp
  if [[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then tmux_clipboard; fi
}

xpanes_install() {
  # see https://github.com/greymd/tmux-xpanes
  wget https://raw.githubusercontent.com/greymd/tmux-xpanes/master/bin/xpanes -O ~/.local/bin/xpanes
  chmod a+x ~/.local/bin/xpanes
}

tmux_clipboard() {
  logger "Please specify what type of clipboard do you want to install for tmux and other command line tools. You can choose 'xclip' for desktop or 'lemonade' for server."
  PS3="Please enter your choice: "
  options=("xclip" "lemonade")

  select opt in "${options[@]}"; do
    case $opt in
      "xclip")
        logger "Installing xclip..."
        sudo apt install -q -y xauth xclip
        ;;

      "lemonade")
        logger "Installing lemonade..."
        lemonade_install

        read -r -p "Lemonade installed. Would you like to install fake-xclip in additional, with lemonade integration? [y/N] " resp
        if [[ "$resp" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
          cp $BASEDIR/utils/xclip ~/.local/bin
          chmod a+x ~/.local/bin/xclip
          logger "Done, fake-xclip installed. Now you can use lemonade calling 'xclip' as an usual."
        fi

        echo "To share clipboard you have to make ssh connection from your Desktop machine to this server. It's better to use autoSSH."
        echo "Connection with port forwarding should looks like this:"
        echo "$ autossh -M 0 -o 'ExitOnForwardFailure yes' -o 'ServerAliveInterval 15' -o 'ServerAliveCountMax 5' -f -N -T -R2489:localhost:2489 username@your_server_ip"
        echo "One last thing: you have to setup ssh keys first. Generate pair on your Desktop and copy public key to the server: '$ ssh-copy-id username@your_server_ip'"
        echo "Then, if you can login to the server without prompt for a password, all is done."
        ;;
      *)
        echo invalid option
        ;;
    esac

    break
  done
}

lemonade_install() {
  LEMONADE_VERSION=`github_latest_tag pocke/lemonade`
  wget -qO- https://github.com/pocke/lemonade/releases/download/v${LEMONADE_VERSION}/lemonade_linux_amd64.tar.gz | tar xvz -C ~/.local/bin
}

xclip_install() {
  sudo apt install xclip
}

###

fzf_install() {
  logger "Installing fzf..."
  rm -rf ~/.fzf
  sudo apt install -q -y highlight silversearcher-ag mediainfo

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}

fd_install() {
  logger "Installing fd..."

  FD_VERSION=$(github_latest_tag sharkdp/fd)
  cd /tmp && wget https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb
  sudo dpkg -i fd_${FD_VERSION}_amd64.deb
}

###

ranger_install() {
  # note: install python first, using ubuntu_extended_install.sh
  logger "Installing Ranger File Manager..."
  sudo apt install -q -y caca-utils highlight atool file w3m poppler-utils mediainfo

  pip3 install --upgrade --user ranger-fm

  # update env variables
  source ~/.bashrc
  # install default ranger config
  ranger --copy-config=all
}

###

main() {
  basic_install

  # tmux_install
  xclip_install

  fzf_install
  fd_install
  ranger_install
}

main
