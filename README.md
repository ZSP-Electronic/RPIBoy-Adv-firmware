# RPIBoy-Advance
A Raspberry Pi Gameboy portable using the Compute module 3+ Lite



### Installation on fresh image:
-------------

1: Clone repository to Host computer
  ````
  git clone https://github.com/ZSPina/RPIBoy-Advance.git
  ````
or
download the zip file

2: Flash retropie image for RPI 2/3 at https://retropie.org.uk/download/ to  micro SD card

3: Copy and Paste contents of "MovetoBoot" folder to boot folder on SD

4: Open wpa_supplicant.conf in text editor and insert SSID and Password between quotation marks ("") and save

5: Insert WIFI dongle into USB port before powering on

6: Power on and ssh into pi

### Install script installer
-----------
  ````
  curl https://raw.githubusercontent.com/ZSPina/RPIBoy-Advance/master/rpiboy_installer.sh >rpiboy_installer.sh
  sudo bash rpiboy_installer.sh
  ````
