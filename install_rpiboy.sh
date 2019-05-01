#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo "Installer must run as root."
   echo "Try sudo"
   exit 1
fi

clear

# Variables-----------------------------------------

if [[ $3 != "" ]; then
   DESTBOOT=$3
else
   DESTBOOT="/boot"
fi

if [[ $4 != "" ]]; then
   DEST=$4
else
   DEST=""
fi

GITHUBPROJECT="RPIBoy-Advance"
PIHOMEDIR="$DEST/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER-"pi"

# Functions-----------------------------------------
execue() {
   if [ $# != 1 ]; then
      echo "ERROR: No args passed"
      exit 1
   fi
   cmd=$1

   echo "EXECUTE: [$cmd]"
   eval "$cmd"
   ret=$?

   if [ $ret != 0 ]; then
      echo "ERROR: Command exited with [$ret]"
      exit 1
   fi

   return 0
}

exists() {
   if [ $# != 1 ]; then
      echo "ERROR: No args passed"
      exit 1
   fi

   file=$1

   if [ -f $file ]; then
      echo "[i] FILE: [$file] exists."
      return 0 
   else
      echo "[i] FILE: [$file] does not exist."
      return 1
   fi
}

# Installation------------------------------------------
echo "Installing..."
echo "Updating package index files..."
apt-get update

echo "Installing python dependancies..."
apt-get install -y --force-yes python-pip python-dev
pip install pyserial --upgrade
pip install progressbar

cd
execute "mkdir $GITHUBPROJECT"
execute "cd /$GITHUBPROJECT"
curl -LO https://raw.githubusercontent.com/ZSPina/RPIBoy-Advance/master/firmware

# Copy service script to directory
#execute "cp runonstart.service /etc/systemd/system/runonstart.service"
#execute "systemctl enable runonstart.service"



# Disable 'wait for network' on boot
#execute "rm -f $DEST/etc/systemd/system/dhcpcd.service.d/wait.conf"

# Copy wifi firmware
#execute "cp $BINDIR/wifi-firmware/rtl* $DEST/lib/firmware/trlwifi/"

echo -e  "Done\n"

echo -n "Reboot now? [y/N] "
read
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then
   echo "Exiting without rebooting."
   exit 0
fi

echo "Rebooting..."
#reboot
exit 0

