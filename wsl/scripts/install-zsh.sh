#!/bin/sh

ZSH_VERSION=$1

apt install -y libncurses-dev

cd /usr/local/src

curl -L https://sourceforge.net/projects/zsh/files/zsh/${ZSH_VERSION}/zsh-${ZSH_VERSION}.tar.xz/download -o zsh-${ZSH_VERSION}.tar.gz
tar xvf zsh-${ZSH_VERSION}.tar.gz
cd zsh-${ZSH_VERSION}

./configure --prefix=/usr --enable-multibyte --with-tcsetpgrp
make
make install

echo '/usr/bin/zsh' >> /etc/shells

cd /usr/local/src
rm -f zsh-${ZSH_VERSION}.tar.gz
