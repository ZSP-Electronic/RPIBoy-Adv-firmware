#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root (sudo)"
  exit 1
fi

GITHUBPROJECT="RPIBoy-Advance"
PIHOMEDIR="$DEST/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER="pi"

#systemctl stop runonstart.service

echo "Updating Firmware..."
cd $BINDIR
git reset --hard HEAD
git pull

chmod +x rpiboy_installer.sh
./rpiboy_installer.sh NO

#systemctl start runonstart.service

echo "Done"