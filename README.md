# BarrierFinder
Provided for EMSE Journal paper verification purpose

Original code provided by Tao Wang, CSC, NCSU
Reproduced by Prof. Frank Mueller

Instructions:
## start off a brand-new ubuntu 15.10 installation
# download ubuntu 15.10 iso
wget http://old-releases.ubuntu.com/releases/15.10/ubuntu-15.10-desktop-amd64.iso

# Refer this tutorial (link in the next line) to prepare the installation USB 
# https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-ubuntu#0

# after successful installation, boot ubuntu 15.10
# then edit /etc/apt/sources.list for old wily repo
sudo echo "deb http://old-releases.ubuntu.com/ubuntu/ wily main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "deb http://old-releases.ubuntu.com/ubuntu/ wily-updates main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "deb http://old-releases.ubuntu.com/ubuntu/ wily-security main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "deb http://old-releases.ubuntu.com/ubuntu/ wily-backports main restricted universe multiverse" >> /etc/apt/sources.list

# install new vim
sudo apt-get install vim

# install openssh-server
sudo apt-get install openssh-server

cd $HOME
git clone https://github.com/twang15/BarrierFinder.git
