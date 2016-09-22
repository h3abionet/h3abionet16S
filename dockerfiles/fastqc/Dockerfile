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
RUN apt-get install -y wget unzip libfindbin-libs-perl

# Install Java 8
# Ref: https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get install -y default-jre

# Install FastQC
# Ref: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/INSTALL.txt
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
RUN unzip fastqc_v0.11.5.zip
RUN mv FastQC/ /opt/
RUN chmod +x /opt/FastQC/fastqc
RUN ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc
##################### INSTALLATION END #####################

ENTRYPOINT ["/usr/local/bin/fastqc"]

CMD ["--help"]
