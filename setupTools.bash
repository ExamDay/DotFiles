#-- TO SET UP SCRIPTS TO RUN ON BASH ALIASES --#
#copy .scripts folder into home directory

#-- BETTER WAY TO REMOVE STUFF --#
sudo apt install trash-cli

#-- REQUIRED --#
sudo apt install git
sudo apt install python3-pip
pip3 install black
pip3 install pep-8

#-- TO INSTALL LATEST GCC AND G++ --#
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-10 g++-10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100

#-- TO INSTALL LATEST Vim AND Vim-gtk3 --# 
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt upgrade
sudo apt install vim
sudo apt install vim-gtk3

#-- TO INSTALL CLANG FORMATTER CLANGD --#
sudo apt install clang-format
sudo apt-get install clangd-10
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 100

#-- OTHER FORMATTERS --#
sudo npm -g install js-beautify
npm install --save-dev --save-exact prettier

#-- REQUIRED FONTS (select one powerline font for powerline to display properly) --#
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

#-- TO INSTALL VUNDLE FOR VIM --# 
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# then make sure the below is at the top of your .vimrc
###### BEGIN
set nocompatible              # be iMproved, required
filetype off                  # required

# set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
# alternatively, pass a path where Vundle should install plugins
#call vundle#begin('~/some/path/here')

# let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

# plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

# All of your Plugins must be added before the following line
call vundle#end()            # required
filetype plugin indent on    # required

###### END

#-- {RENDERED OBSOLETE BY TABNINE} PLUGIN TO INSTALL YouCompleteMe FOR Vim --#
[install YouCompleteMe via Vundle]
apt install build-essential cmake python3-dev
apt install mono-complete golang nodejs default-jdk npm
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all

#-- TO INSTALL VeryMagic FOR Vim --#
# go to vimball folder. open all vimballs there in vim and run :source % in normal mode.
# copy enchanted.vim in VimPlugins folder into ~/.vim/plugin folder

#-- TO INSTALL CYBERGHOST VPN AND RUN ON STARTUP (may or may not work) --#
cd PATH/TO/CYBERGHOST/FOLDER
sudo bash install.sh
sudo cyberghostvpn --traffic --country-code US --connect
sudo bash -c 'echo -e "#!/bin/bash\nsudo cyberghostvpn --traffic --country-code US --connect" > /etc/init.d/vpn.bash'  # setup vpn to run on startup
