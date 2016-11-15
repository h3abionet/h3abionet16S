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

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/rename_fastq_headers.sh
RUN chmod +x rename_fastq_headers.sh
RUN mv rename_fastq_headers.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_derep_workaround.sh
RUN chmod +x uparse_derep_workaround.sh
RUN mv uparse_derep_workaround.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/concat_fasta.sh
RUN chmod +x concat_fasta.sh
RUN mv concat_fasta.sh /usr/local/bin/

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/generate_R_reports.R
RUN chmod +x generate_R_reports.R
RUN mv generate_R_reports.R /usr/local/bin/

##################### INSTALLATION END #####################

