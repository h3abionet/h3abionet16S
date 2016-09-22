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
RUN apt-get install -y wget unzip sudo libfile-util-perl

# Install USEARCH
# Ref: http://www.drive5.com/usearch/manual/install.html
#ADD usearch8.1.1861_i86linux32 /usr/local/bin/
COPY usearch8.1.1861_i86linux32 /usr/local/bin/
RUN chmod +x /usr/local/bin/usearch8.1.1861_i86linux32
RUN ln -s /usr/local/bin/usearch8.1.1861_i86linux32 /usr/local/bin/usearch8

RUN wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip
RUN unzip fasta-splitter-0.2.4.zip
RUN chmod +x fasta-splitter.pl
RUN mv fasta-splitter.pl /usr/local/bin/

# Install scripts
RUN wget http://drive5.com/python/python_scripts.tar.gz \
    && tar zxvf python_scripts.tar.gz -C /usr/local/bin/
RUN head -n 1 /usr/local/bin/uc2otutab.py | if grep -q "\#\!\/usr\/bin\/python"; then echo "found"; else echo "#"'!'"/usr/bin/python" | cat - /usr/local/bin/uc2otutab.py > /tmp/uc2otutab.py.tmp; chmod +x /tmp/uc2otutab.py.tmp; sudo mv /tmp/uc2otutab.py.tmp /usr/local/bin/uc2otutab.py; fi

RUN wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_global_search_workaround.sh
RUN chmod +x uparse_global_search_workaround.sh
RUN mv uparse_global_search_workaround.sh /usr/local/bin/
##################### INSTALLATION END #####################

#ENTRYPOINT ["/usr/local/bin/usearch8.1.1861_i86linux32"]
#ENTRYPOINT ["/usr/local/bin/usearch8"]
