#!/bin/bash
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color
echo -e "${YELLOW}Welcome to the installer!"
echo -e "${YELLOW}Downloading installation files...${NC}"
cd 
wget https://zippyoppenheimer.com/pi_setup.tar.gz.gpg
echo -e "${YELLOW}Verifying files..."
SHA1CHECKSUM=$(sha1sum pi_setup.tar.gz.gpg)
if [[ "$SHA1CHECKSUM" == "c6f69007eb9832d19829aed0006607532548e531  pi_setup.tar.gz.gpg" ]]
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

#echo "When prompted, enter the user password (default: raspberry)"
echo -e "${YELLOW}Installing startup files...${NC}"
sudo rm /etc/rc.local
sudo cp /home/pi/pi_setup/rc.local /etc/rc.local
echo -e "${YELLOW}installing putty tools...${NC}"
echo -e "${YELLOW}If prompted. press Y and hit enter.${NC}"
sudo apt-get update
sudo apt-get install putty putty-tools
echo -e "${YELLOW}Installation of putty tools done, installing python scripts...${NC}"
echo "python pi_setup/gpio_button.py" >> ~/.bashrc
chmod +x pi_setup/gdrive
sudo cp pi_setup/gdrive /usr/local/bin/
sudo rm /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo cp getty@tty1.service /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo systemctl daemon-reload
echo -e "${GREEN}Done! A reboot is required."
echo -e "${NC} "
