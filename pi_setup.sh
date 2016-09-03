#!/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color
echo -e "${YELLOW}Welcome to the installer!"
echo -e "${YELLOW}Downloading installation files...${NC}"
sudo mkdir /mnt/usb
sudo chown pi /mnt/usb
cd 
wget https://github.com/ninjas28/RPi-TinyG-Control/raw/master/pi_setup.tar.gz.gpg
echo -e "${YELLOW}Verifying files..."
SHA1CHECKSUM=$(sha1sum pi_setup.tar.gz.gpg)
if [[ "$SHA1CHECKSUM" == "2e6d8ad0250df85a3a446e341e3ceda891c828c7  pi_setup.tar.gz.gpg" ]]
then
	echo -e "${GREEN}Files verified, continuing with installation."
else
	echo -e "${RED}File verification failed, try rerunning this script."
	exit 1
fi
echo -e "${YELLOW}Please decrypt the installation files."
echo -e "${YELLOW}Enter your password when prompted.${NC}"
gpg pi_setup.tar.gz.gpg
tar -xzvf pi_setup.tar.gz
echo -e "${YELLOW}Installing wifi connectivity..."
echo -e "${YELLOW}This will require sudo permissions.${NC}"
sudo rm /etc/network/interfaces
sudo cp /home/pi/pi_setup/interfaces /etc/network/
echo -e "${YELLOW}Installing startup files...${NC}"
sudo rm /etc/rc.local
sudo cp /home/pi/pi_setup/rc.local /etc/rc.local
echo -e "${YELLOW}installing putty tools...${NC}"
#echo -e "${YELLOW}If prompted. press Y and hit enter.${NC}"
sudo apt-get update
sudo apt-get -y install putty putty-tools python-dev python-smbus git build-essential ntpdate
echo -e "${YELLOW}Installation of putty tools done, installing python scripts...${NC}"
cp pi_setup/.bashrc ~/.bashrc
chmod +x pi_setup/gdrive
sudo cp pi_setup/gdrive /usr/local/bin/
sudo rm /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo cp /home/pi/pi_setup/getty@tty1.service /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo systemctl daemon-reload
cd pi_setup/Adafruit_Python_ADS1x15
sudo python setup.py install
cd 
echo -e "${YELLOW}You will need to manually navigate and enable I2C on the Pi"
echo -e "${YELLOW}Navigate to Advanced Options, and then I2C to enable I2C"
echo -e "${YELLOW}Hit Tab, and then select Finish to exit when done."
read -p "Press [Enter] key to continue..."
sudo raspi-config
echo -e "${GREEN}Done! A reboot is required."
echo -e "${NC} "
