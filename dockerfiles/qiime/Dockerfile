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
RUN apt-get install -y wget bzip2 libxext6 libsm6 libxrender1

# Install QIIME
# Ref: http://qiime.org/install/install.html
# Based on https://hub.docker.com/r/continuumio/miniconda/~/dockerfile/
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH
RUN /opt/conda/bin/conda create -y -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
RUN /opt/conda/bin/conda install psutil
ENV PATH /opt/conda/envs/qiime1/bin:$PATH
##################### INSTALLATION END #####################

#ENTRYPOINT ["print_qiime_config.py"]
