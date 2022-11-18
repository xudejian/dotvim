#!/bin/bash

hash dnf && {
  sudo dnf install -y epel-release epel-next-release
  sudo dnf config-manager --set-enabled powertools
  sudo dnf install -y sqlite wget pciutils

  sudo dnf groupinstall -y 'Development Tools'
  sudo dnf groupinstall -y "fonts"

  [ -f /snap ] || {
    sudo dnf install -y snapd
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
  }

  sudo dnf install -y autojump-zsh

  sudo dnf install -y http://galaxy4.net/repo/galaxy4-release-8-current.noarch.rpm
  sudo dnf install -y tmux

  sudo dnf module install -y nodejs:16

  [ -f ~/.config/nvim/init.vim ] || {
    mkdir -p ~/.local/share/nvim
    mkdir -p ~/.config/nvim
    ln -s ~/.vim ~/.local/share/nvim/site
    ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
    sudo dnf install -y neovim python3-neovim
  }
  hash feh || {
    sudo dnf install -y imlib2-devel libcurl-devel libXt-devel
    cd /tmp/
    wget https://feh.finalrewind.org/feh-3.9.1.tar.bz2
    tar -xjf feh-3.9.1.tar.bz2
    cd feh-3.9.1
    make && sudo make install
  }

  [ -f /dev/virtio-ports/com.redhat.spice.0 ] || {
     sudo dnf install -y spice-vdagent
  }
  [ -f /usr/bin/google-chrome ] || {
    sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
  }
}

# 150
#
[ -f .local/share/fonts/CascadiaCodePL.ttf ] || {
  mkdir -p ~/.local/share/fonts/
  mkdir -p /tmp/cascadiacode
  cd /tmp/cascadiacode
  wget https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
  unzip CascadiaCode-2111.01.zip
  mv /tmp/cascadiacode/ttf/Cascadia*.ttf ~/.local/share/fonts/
  cd
  fc-cache -v
}

# 2196
#
[ -f ~/src/dwm ] || {
  hash dnf && sudo dnf -y install xorg-x11-server-Xorg xorg-x11-drv-{evdev,intel,synaptics} \
    xorg-x11-xinit liberation-fonts \
    xorg-x11-utils \
    libX11-devel libXft-devel libXinerama-devel
  hash apt && sudo apt install build-essential libx11-dev libxft-dev libxinerama-dev libfreetype6-dev libfontconfig1-dev
  mkdir -p ~/src
  cd ~/src
  git clone git://git.suckless.org/dwm
  git clone git://git.suckless.org/dmenu
  git clone git://git.suckless.org/st
  cd
}

# 1642
#
[ -f $HOME/.cargo/env ] || {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
cargo install ripgrep fd-find
