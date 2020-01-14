#!/usr/bin/env bash
PKGLIST="
build-essential
git
cvs
g++
clang
autoconf
automake
cmake
pkg-config
gettext
libxml2-utils
libevent-dev
libncurses5-dev
exuberant-ctags
xsel
colordiff
libtool
libtool-bin
unzip
schroot
debootstrap
samba
libgtk-3-dev
python-dev
python-pip
python3-dev
python3-pip
sublime-text
meld
gtkterm
minicom
spotify-client
"
sudo apt install $PKGLIST

# Add multiarch support
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libc6:i386 libncurses5:i386 libstdc++6:i386

# Neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim

# Clang packages (for Ubuntu 16.04 - https://apt.llvm.org/)
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt install clang-4.0 clang-4.0-doc libclang-common-4.0-dev libclang-4.0-dev libclang1-4.0 libclang1-4.0-dbg libllvm-4.0-ocaml-dev libllvm4.0 libllvm4.0-dbg lldb-4.0 llvm-4.0 llvm-4.0-dev llvm-4.0-doc llvm-4.0-examples llvm-4.0-runtime clang-format-4.0 python-clang-4.0 libfuzzer-4.0-dev

#
# Build packages from sources
#
PREFIX=/usr/local
BIN_DIR="$HOME/bin"
BUILD_DIR="$HOME/build"
mkdir -p $BIN_DIR $BUILD_DIR
cd $BUILD_DIR

# ranger
git clone https://github.com/ranger/ranger.git
(
  cd ranger
  sudo make prefix=$PREFIX install
)

# tmux
git clone https://github.com/tmux/tmux.git
(
  cd tmux
  sh autogen.sh
  ./configure && make && sudo make prefix=$PREFIX install
)

# xcape
git clone https://github.com/alols/xcape.git
(
  cd xcape
  make && sudo make prefix=$PREFIX install
)

# Powerline fonts
git clone https://github.com/powerline/fonts.git
(
  cd fonts
  ./install.sh
)
rm -rf fonts

# gitsh
curl -OL https://github.com/thoughtbot/gitsh/releases/download/v0.12/gitsh-0.12.tar.gz
(
  cd gitsh-0.12
  ./configure && make && sudo make prefix=$PREFIX install
)

# vte-ng
sudo apt install autoconf libglib2.0-dev gtk-doc-tools
git clone https://github.com/thestinger/vte-ng.git
(
  cd vte-ng
  sh autogen.sh
  make && sudo make prefix=$PREFIX install
)

# termite
git clone https://github.com/thestinger/termite.git
(
  cd termite
  make && sudo make prefix=$PREFIX install
)

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git
(
  cd fzf
  ./install
)

# rtags
git clone --recursive https://github.com/Andersbakken/rtags.git
(
  cd rtags
  rm -rf build
  mkdir build && cd build
  cmake ..
  make && sudo make prefix=$PREFIX install
)

# cquery
git clone --recursive https://github.com/cquery-project/cquery.git
(
  cd cquery
  rm -rf build
  mkdir build && cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
  cmake --build .
  cmake --build . --target install
)
