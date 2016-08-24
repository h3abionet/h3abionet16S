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
RUN apt-get install -y wget bzip2

# Install QIIME
# Ref: http://qiime.org/install/install.html
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN printf "\n yes" | bash Miniconda3-latest-Linux-x86_64.sh
#RUN echo "export PATH=/root/miniconda3/bin:$PATH" >> /root/.bashrc
ENV PATH=/root/miniconda3/bin:$PATH
RUN printf "y" | /root/miniconda3/bin/conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
RUN /root/miniconda3/bin/conda install psutil
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source activate qiime1
##################### INSTALLATION END #####################

ENTRYPOINT ["print_qiime_config.py"]
