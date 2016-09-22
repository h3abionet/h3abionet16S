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
RUN apt-get install -y wget unzip bzip2 apt-utils imagemagick

# Install house and helper scripts

RUN wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
RUN tar jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2  -C /usr/local/

RUN wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip
RUN unzip fasta-splitter-0.2.4.zip
RUN chmod +x fasta-splitter.pl
RUN mv fasta-splitter.pl /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/rename_fastq_headers.sh
RUN chmod +x rename_fastq_headers.sh
RUN mv rename_fastq_headers.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_derep_workaround.sh
RUN chmod +x uparse_derep_workaround.sh
RUN mv uparse_derep_workaround.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/concat_fasta.sh
RUN chmod +x concat_fasta.sh
RUN mv concat_fasta.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/fasta_number.py
RUN chmod +x fasta_number.py
RUN mv fasta_number.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uc2otutab.py
RUN chmod +x uc2otutab.py
RUN mv uc2otutab.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/die.py
RUN mv die.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/fasta.py
RUN mv fasta.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/progress.py
RUN mv progress.py /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uc.py
RUN mv uc.py /usr/local/bin/

# Based on https://hub.docker.com/r/continuumio/miniconda/~/dockerfile/
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH
##################### INSTALLATION END #####################

