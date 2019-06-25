#!/bin/bash
# Takes about 100 mins to install pyTorch on a TX2
# # Note: Please install in SD Card or else you will run out of space in TX2.
#
# pyTorch install script ONLY for NVIDIA Jetson TX2-Ubuntu 16.04-L4T, might not work on NVIDIA TX1.
# from a fresh flashing of JetPack 2.3.1 / JetPack 3.0 / JetPack 3.1
#
# for the full source build, see jetson-reinforcement repo:
# https://github.com/dusty-nv/jetson-reinforcement/blob/master/CMakePreBuild.sh
#
# Note:  pyTorch documentation calls for use of Anaconda,
#        however Anaconda isn't available for aarch64.
#        Instead, we install directly from source using setup.py


RED='\033[0;31m' # Red
Yel='\033[0;33m' # Yellow
NC='\033[0m' # No Color

printf "Current Path is: ${RED}$PWD\n${NC}"
printf "Installing in $PWD. ${RED}Installing in internal NVIDIA hard drive is not recommended. Please install in the SD Card. \n${Yel}Do you want to continue? [Y/N] ${NC}"
read answer

if [[ $answer == "Y" || $answer == "y" || $answer == "yes" || $answer == "Yes" || $answer == "YES" ]]; then

# Choose Python version:
printf "${RED}Choose Python(2.7 or 3) Version: [2,3] ${NC}"
read ver 

########################## For python 2 ##########################
if [ $ver -eq 2 ]; then

printf "${Yel}Installing pyTorch for Python-2.7${NC}"
# Install Python-pip:
printf "${Red}Installing and updating pip${NC}"
sudo apt-get install python-pip

# Upgrade pip:
pip install -U pip
pip --version
# pip 9.0.1 from /home/ubuntu/.local/lib/python2.7/site-packages (python 2.7)

# Clone pyTorch repo:
printf "${Yel}Cloning PyTorch from source.${NC}"
git clone http://github.com/pytorch/pytorch
cd pytorch
git submodule update --init

# Install prereqs
printf "${Red}Installing dependencies.${NC}"
sudo pip install -U setuptools
sudo pip install -r requirements.txt

# Install cmake:
printf "${Yel}Installing Cmake.${NC}"
sudo apt install cmake

# Develop Mode:
printf "${Red}Building Develop Mode${NC}\n${Yel}This might take an hour.${NC}"
python setup.py build_deps # Will take about an hour on TX2
sudo python setup.py develop

# Install Mode:  (substitute for Develop Mode commands) # Will take about 30 mins on TX2
sudo python setup.py install

# Install TorchVision:
printf "${Yel}Installing Torch Vision.${NC}"
sudo apt-get install libjpeg-dev zlib1g-dev libpng-dev python-matplotlib
sudo -H pip install Pillow
sudo -H pip install torchvision

# Verify CUDA (If this works, Torch is successfully installed)
printf "${Red}Verifying Pytorch. Note: CUDA should be installed successfully.${NC}"
python -c 'import torch; print(torch.__version__); print(torch.cuda.is_available()); a = torch.cuda.FloatTensor(2); \
print(a); b = torch.randn(2).cuda(); print(b); c = a + b; print(c)'

########################## For python 3 ##########################

# Python 3:  
elif [ $ver -eq 3 ]; then

echo "Installing pyTorch for Python-3"

printf "${Yel}Installing pyTorch for Python-3${NC}"
# Install Python-pip:
printf "${Red}Installing and updating pip${NC}"
sudo apt-get install python3-pip

# Upgrade pip:
pip3 install -U pip
pip3 --version

# Clone pyTorch repo:
printf "${Yel}Cloning PyTorch from source.${NC}"
git clone http://github.com/pytorch/pytorch
cd pytorch
git submodule update --init

# Install prereqs
printf "${Red}Installing dependencies.${NC}"
sudo pip3 install -U setuptools
sudo pip3 install -r requirements.txt

# Install cmake:
printf "${Yel}Installing Cmake.${NC}"
sudo apt install cmake

# Develop Mode:
printf "${Red}Building Develop Mode${NC}\n${Yel}This might take an hour.${NC}"
python3 setup.py build_deps # Will take about an hour on TX2
sudo python3 setup.py develop

# Install Mode:  (substitute for Develop Mode commands) # Will take about 30 mins on TX2
sudo python3 setup.py install

# Install TorchVision:
printf "${Yel}Installing Torch Vision.${NC}"
sudo apt-get install libjpeg-dev zlib1g-dev libpng-dev python3-matplotlib
sudo -H pip3 install Pillow
sudo -H pip3 install torchvision

# Verify CUDA (If this works, Torch is successfully installed)
printf "${Red}Verifying Pytorch. Note: CUDA should be installed successfully.${NC}"
python3 -c 'import torch; print(torch.__version__); print(torch.cuda.is_available()); a = torch.cuda.FloatTensor(2); \
print(a); b = torch.randn(2).cuda(); print(b); c = a + b; print(c)'

else
	printf "${RED}Invalid version, choose 2 or 3. Re-run the script{NC}";
fi

else
printf "${RED}Change path somewhere in SD card (highly recommended).${NC}\nYou can still install pytorch in any other folder but is not recommended."
fi
