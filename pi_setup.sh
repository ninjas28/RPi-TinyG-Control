#!/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
echo -e "${YELLOW}Welcome to the installer!"
echo -e "${YELLOW}Downloading installation files..."
cd 
wget https://zippyoppenheimer.com/pi_setup.tar.gz.gpg
echo -e "${YELLOW}Verifying files..."
SHA1CHECKSUM=$(sha1sum pi_setup.tar.gz.gpg)
if [[ "$SHA1CHECKSUM" == "77018c47c1a5167ecbd59a272c8fa2f073ebf2bf" ]]
then
	echo -e "${GREEN}Files verified, continuing with installation."
else
	echo -e "${RED}File verification failed, try rerunning this script."
	exit 1
fi
echo -e "${YELLOW}Please decrypt the installation files."
echo -e "${YELLOW}Enter your password when prompted."
gpg pi_setup.tar.gz.gpg
tar -xzvf pi_setup.tar.gz
echo -e "${YELLOW}Installing wifi connectivity..."
echo -e "${YELLOW}This will require sudo permissions."
sudo rm /etc/network/interfaces
sudo cp /home/pi/pi_setup/interfaces /etc/network/

#echo "When prompted, enter the user password (default: raspberry)"
echo -e "${YELLOW}Installing startup files"
sudo rm /etc/rc.local
sudo cp /home/pi/pi_setup/rc.local /etc/rc.local
echo -e "${YELLOW}installing putty tools..."
echo -e "${YELLOW}If prompted. press Y and hit enter."
sudo apt-get update
sudo apt-get install putty putty-tools
echo -e "${YELLOW}Installation of putty tools done, installing python GPIO script"
echo "python pi_setup/gpio_button.py" >> ~/.bashrc
sudo rm /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo cp getty@tty1.service /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo systemctl daemon-reload
echo -e "${GREEN}Done! A reboot is required."