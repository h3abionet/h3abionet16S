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
RUN apt-get install -y wget unzip bzip2 apt-utils

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

# Install USEARCH
# Ref: http://www.drive5.com/usearch/manual/install.html
#ADD usearch8.1.1861_i86linux32 /usr/local/bin/
COPY usearch8.1.1861_i86linux32 /usr/local/bin/
RUN chmod +x /usr/local/bin/usearch8.1.1861_i86linux32
RUN ln -s /usr/local/bin/usearch8.1.1861_i86linux32 /usr/local/bin/usearch8

# Install QIIME
# Ref: http://qiime.org/install/install.html
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
#RUN bash Miniconda3-latest-Linux-x86_64.sh
RUN printf "\n yes" | bash Miniconda3-latest-Linux-x86_64.sh
RUN echo "export PATH=/root/miniconda3/bin:$PATH" >> /root/.bashrc
#RUN PATH=/root/miniconda3/bin:$PATH
#RUN export PATH
RUN printf "y" | /root/miniconda3/bin/conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
RUN /root/miniconda3/bin/conda install psutil

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

# Install house and helper scripts

RUN wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
RUN tar jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2  -C /usr/local/
RUN wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip

RUN unzip fasta-splitter-0.2.4.zip
RUN chmod +x fasta-splitter.pl
RUN mv fasta-splitter.pl /usr/local/bin/

##################### INSTALLATION END #####################

