#!/bin/bash

# Install prerequesites
apt-get install ninja-build gettext cmake unzip curl python3 python3-pip

# Install neovim
git clone https://github.com/neovim/neovim && cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo && make install
cd .. && rm -r neovim

# Install a package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.config && git clone git@github.com:xR3b0rn/nvim-setup.git ~/.config/nvim