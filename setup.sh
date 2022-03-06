#!/bin/bash

# SETUP DART TUTORIAL

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo
echo "======= CHECKING WE ARE ON A CODIO BOX ======="
if [ -v CODIO_HOSTNAME ]
then
	echo "Codio box detected"
	echo "continuing setup"
else
	echo "no Codio box detected"
	echo "exiting setup"
	exit 1
fi

echo
echo "============ INSTALLING PACKAGES ============"
sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'  
sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y dart
sudo apt autoremove -y

echo
echo "==== INSTALLING AND CONFIGURING MYSQL ======"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password passDart'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password passDart'
# the above steps need to be completed BEFORE installing mysql!
sudo apt -y install mysql-server mysql-client

FILENAME="/etc/mysql/mysql.conf.d/mysqld.cnf"
SEARCH="127.0.0.1"
REPLACE="0.0.0.0"
sudo sed -i "s/$SEARCH/$REPLACE/gi" $FILENAME

# disable secure file privileges (so we can import a csv file)
echo 'secure_file_priv=""' | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf

sudo /etc/init.d/mysql restart


echo "=========== CONFIGURING BASH ============="

# /usr/lib/dart/bin
# export PATH='$PATH:/usr/lib/dart/bin'
if grep dart ~/.profile
then
  echo "path includes dart binaries"
else
  echo "path to dart binaries needs adding"
  echo "export PATH='$PATH:/usr/lib/dart/bin'" >> ~/.profile
fi




source ~/.profile
echo
echo "dart successfully installed"
dart --version