#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
ZSH_VERSION=5.7.1

# Compile & install ZSH
if [ ! -f /usr/bin/zsh ]
then
  sudo "${SCRIPT_DIR}/install-zsh.sh" ${ZSH_VERSION}
fi;

if [ -d ~/.oh-my-zsh ]
then
  echo "Oh-My-Zsh is installed"
  exit
fi;

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --skip-chsh --unattended"

mkdir -p ~/.oh-my-zsh/custom/plugins/symfony2
chmod 755 ~/.oh-my-zsh/custom/plugins/symfony2
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/symfony2/symfony2.plugin.zsh \
  > ~/.oh-my-zsh/custom/plugins/symfony2/symfony2.plugin.zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chmod 755 ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Enable plugins
sed 's/plugins=(git)/plugins=(git symfony2 zsh-syntax-highlighting)/g' ~/.zshrc > ~/zshrc-new
mv -f ~/zshrc-new ~/.zshrc
