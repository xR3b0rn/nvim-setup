#!/bin/bash

# Install prerequesites
apt-get install -y ninja-build gettext cmake unzip curl python3 python3-pip clang-format ripgrep fd-find

# Install neovim
git clone https://github.com/neovim/neovim && cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo && make install
cd .. && rm -r neovim

# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.config && git clone https://github.com/xR3b0rn/nvim-setup.git ~/.config/nvim

python3 -m pip install pynvim

apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
