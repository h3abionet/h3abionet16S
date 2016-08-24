############################################################
# Dockerfile to build 16S rRNA diversity analysis
# Based on Ubuntu 16.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Long Yee "long@sanbi.ac.za"

# Update the repository sources list
RUN apt-get update
RUN apt-get upgrade -y

WORKDIR /root

################## BEGIN INSTALLATION ######################
# Install Basic tools
RUN apt-get install -y wget 

# Install USEARCH
# Ref: http://www.drive5.com/usearch/manual/install.html
ADD usearch8.1.1861_i86linux32 /usr/local/bin/
RUN chmod +x /usr/local/bin/usearch8.1.1861_i86linux32
RUN ln -s /usr/local/bin/usearch8.1.1861_i86linux32 /usr/local/bin/usearch8

# Install scripts
RUN wget http://drive5.com/python/python_scripts.tar.gz
RUN tar zxvf python_scripts.tar.gz -C /usr/local/bin/
##################### INSTALLATION END #####################

ENTRYPOINT ["/usr/local/bin/usearch8.1.1861_i86linux32"]
