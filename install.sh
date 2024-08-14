#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  ninja-build \
  gettext \
  cmake \
  unzip \
  curl \
  python3 \
  python3-pip \
  clang-format \
  ripgrep \
  fd-find \
  npm \
  git

# Install python<version>-venv
# Some language server do create a python3-venv  (e.g. the LSP for CMake)
sudo apt-get install -y $(readlink $(which python3))-venv python3-neovim

git clone https://github.com/neovim/neovim
cd neovim
git checkout v0.10.1
make CMAKE_BUILD_TYPE=RelWithDebInfo -j16
sudo make install
cd .. 
rm -rf neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Run PackerSync to install required packages
nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Install oh-my-zsh
apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

