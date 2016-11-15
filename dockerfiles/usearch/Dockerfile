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
RUN apt-get install -y wget unzip bzip2 sudo libfile-util-perl

# Install USEARCH
# Follow instructions to get usearch here: http://www.drive5.com/usearch/download.html and then download from the link send by an email to the directory in which this Docker file resides. This is important! 
# E.g. cd /directory_where_this_docker_file_is; wget http://link_in_email -O usearch
COPY usearch /usr/local/bin/
RUN chmod +x /usr/local/bin/usearch

RUN wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip
RUN unzip fasta-splitter-0.2.4.zip
RUN chmod +x fasta-splitter.pl
RUN mv fasta-splitter.pl /usr/local/bin/

# Based on https://hub.docker.com/r/continuumio/miniconda/~/dockerfile/
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

# Install scripts
RUN wget http://drive5.com/python/python_scripts.tar.gz \
    && tar zxvf python_scripts.tar.gz -C /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_global_search_workaround.sh
RUN chmod +x uparse_global_search_workaround.sh
RUN mv uparse_global_search_workaround.sh /usr/local/bin/
##################### INSTALLATION END #####################
