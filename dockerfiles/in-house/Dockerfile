############################################################
# Dockerfile to build 16S rRNA diversity analysis
# Based on Ubuntu 16.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Gerrit Botha "gerrit.botha@uct.ac.za.za"

WORKDIR /root

################## BEGIN INSTALLATION ######################
# Install Basic tools
RUN apt-get update && apt-get install -y wget unzip bzip2 apt-utils imagemagick

# Install house and helper scripts

RUN wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
RUN tar jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2  -C /usr/local/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/rename_fastq_headers.sh
RUN chmod +x rename_fastq_headers.sh
RUN mv rename_fastq_headers.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_derep_workaround.sh
RUN chmod +x uparse_derep_workaround.sh
RUN mv uparse_derep_workaround.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/concat_fasta.sh
RUN chmod +x concat_fasta.sh
RUN mv concat_fasta.sh /usr/local/bin/

# Get seqtk installed
RUN apt-get install -y git make gcc libz-dev
RUN git clone https://github.com/lh3/seqtk && cd seqtk && make
RUN mv seqtk/seqtk /usr/local/bin/

################## Hex specific ###########################
RUN mkdir -p /researchdata/fhgfs

################## Tromso specific ###########################
RUN mkdir -p /mnt/data
RUN mkdir -p /mnt/data2
RUN mkdir -p /mnt/nas2


##################### INSTALLATION END #####################
