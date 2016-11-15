#!/bin/bash
############################################################
# Install tools for 16S rRNA diversity analysis
# Based on Ubuntu 16.04
############################################################

# Install docker
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get -y install docker-engine
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

# Executing the Docker Command Without Sudo 
sudo usermod -aG docker $(whoami)

# If the VM is running on OpenStack 
# Ref: https://rahulait.wordpress.com/2016/02/28/modifying-default-mtu-for-docker-containers/
#sudo cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service
sed '12s/$/ --mtu=1450/' /lib/systemd/system/docker.service | sudo tee /etc/systemd/system/docker.service
sudo systemctl daemon-reload
sudo service docker restart

# Install CWL
sudo apt-get -y install python-pip
pip install cwlref-runner
pip install --upgrade pip

# Install USEARCH
sudo mv usearch8.1.1861_i86linux32 /usr/local/bin/
sudo chmod +x /usr/local/bin/usearch8.1.1861_i86linux32

# Make some directories to hold data
mkdir -p input output dbs

# Get source code
git clone https://github.com/h3abionet/h3abionet16S.git

# Build docker containers from Dockfiles
cd h3abionet16S/dockerfiles/
sudo docker build --tag longyee/fastqc fastqc/
sudo docker build --tag longyee/qiime
sudo docker build --tag longyee/usearch usearch/
sudo docker build --tag longyee/r r/
sudo docker build --tag longyee/in-house in-house/
