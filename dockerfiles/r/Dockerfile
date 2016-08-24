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

# Install R
# Ref: https://www.datascienceriot.com/how-to-install-r-in-linux-ubuntu-16-04-xenial-xerus/kris/
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list'
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN apt-get update
RUN apt-get -y install r-base r-base-dev
RUN apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""

RUN su - -c "R -e \"source('https://bioconductor.org/biocLite.R')\""
RUN su - -c "R -e \"install.packages('NMF', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"devtools::install_github('joey711/phyloseq')\""
RUN su - -c "R -e \"install.packages('gridExtra', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('ggplot2', repos = 'http://cran.rstudio.com/')\""

##################### INSTALLATION END #####################

CMD ["R"]
