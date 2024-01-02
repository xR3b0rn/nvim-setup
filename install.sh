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
sudo apt-get install -y $(readlink $(which python3))-venv

python3 -m pip install neovim

git clone https://github.com/neovim/neovim && cd neovim && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install && \
  cd .. && rm -r neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/xR3b0rn/nvim-setup.git

# First install required setup files for packer
cd nvim-setup
mkdir -p ~/.config/nvim/lua/setup
cp init.lua ~/.config/nvim/.
cp lua/setup/* ~/.config/nvim/lua/setup/.
cd ..

# Run PackerSync to install required packages
nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Install configurations for previously installed packages
cp -r nvim-setup/* ~/.config/nvim/.

rm -r nvim-setup

# Install oh-my-zsh
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

