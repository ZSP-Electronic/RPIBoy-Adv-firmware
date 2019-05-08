#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo "Installer must run as root."
   echo "Try sudo"
   exit 1
fi


# Variables-----------------------------------------

if [[ $3 != "" ]]; then
   DESTBOOT=$3
else
   DESTBOOT="/boot"
fi

if [[ $4 != "" ]]; then
   DEST=$4
else
   DEST=""
fi

if [[ $1 == "NO" ]]; then
	FINSTALL=0
else
	FINSTALL=1
fi

GITHUBPROJECT="RPIBoy-Advance"
PIHOMEDIR="$DEST/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER="pi"

# Functions-----------------------------------------
execute() {
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
if [ $FINSTALL == 1 ]; then
	echo "Updating package index files..."
	apt-get update

	echo "Installing python dependancies..."
	apt-get install -y --force-yes python-pip python-dev
	pip install pyserial --upgrade
	pip install progressbar

	cd $PIHOMEDIR
	git clone --recursive https://github.com/ZSPina/RPIBoy-Adv-firmware.git
	mv RPIBoy-Adv-firmware RPIBoy-Advance
	cd RPIBoy-Advance
fi

cd firmware

# Flash controller code -----------------------------------------------
#python ./stm32_firmware/stm32Programmer.py -e -w -v -P 17,18 -p /dev/serial0 ./stm32_firmware.bin

if [ $FINSTALL == 1 ]; then
	# Copy service script to directory ------------------------------------
	#cp runonstart.service /etc/systemd/system/runonstart.service
	#systemctl enable runonstart.service

	# Disable 'wait for network' on boot ----------------------------------
	#rm -f $DEST/etc/systemd/system/dhcpcd.service.d/wait.conf

	# Copy wifi firmware
	cp $BINDIR/firmware/wifi-firmware/rtl* $DEST/lib/firmware/rtlwifi/
fi

echo -e  "Done\n"

exit 0

