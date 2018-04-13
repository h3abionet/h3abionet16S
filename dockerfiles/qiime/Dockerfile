############################################################
# Dockerfile to build 16S rRNA diversity analysis
# Based on Ubuntu 16.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Gerrit Botha "gerrit.botha@uct.ac.za"

WORKDIR /root

################## BEGIN INSTALLATION ######################
# Install Basic tools
RUN apt-get update && apt-get install -y wget bzip2 libxext6 libsm6 libxrender1 libglib2.0-0

# Install QIIME
# Ref: http://qiime.org/install/install.html
# Based on https://hub.docker.com/r/continuumio/miniconda/~/dockerfile/
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH
RUN /opt/conda/bin/conda create -y -n qiime1 python=2.7 numpy=1.10.4 qiime matplotlib=1.4.3 mock nose scikit-bio cogent -c bioconda
# Not sure why we had psutil install system wide
RUN /opt/conda/bin/conda install psutil
# Need to downgrade h5py otherwise we get Unicode incompatibility issues
RUN /opt/conda/bin/conda install -n qiime1 h5py=2.6.0
ENV PATH /opt/conda/envs/qiime1/bin:$PATH

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/strip_primers.py
RUN chmod +x strip_primers.py
RUN mv strip_primers.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/truncate_seq_len.py
RUN chmod +x truncate_seq_len.py
RUN mv truncate_seq_len.py /usr/local/bin

################## Hex specific ###########################
RUN mkdir -p /researchdata/fhgfs

################## Tromso specific ###########################
RUN mkdir -p /mnt/data
RUN mkdir -p /mnt/data2
RUN mkdir -p /mnt/nas2

##################### INSTALLATION END #####################

#ENTRYPOINT ["print_qiime_config.py"]
