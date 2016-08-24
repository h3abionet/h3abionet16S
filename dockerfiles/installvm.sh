sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install default-jre

wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
unzip fastqc_v0.11.5.zip
sudo mv FastQC/ /opt/
sudo cd /opt/FastQC
sudo chmod +x fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc

wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
sudo tar jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2  -C /usr/local/

wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip
unzip fasta-splitter-0.2.4.zip
chmod +x fasta-splitter.pl
sudo mv fasta-splitter.pl /usr/local/bin/

#sudo mv usearch8.1.1861_i86linux32 /usr/local/bin/
#sudo chmod +x /usr/local/bin/usearch8.1.1861_i86linux32

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo bash Miniconda3-latest-Linux-x86_64.sh

conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
conda install psutil
source activate qiime1
print_qiime_config.py -t

sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
sudo gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
sudo gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install r-base

sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""

sudo su - -c "R -e \"source(‘https://bioconductor.org/biocLite.R’)\""
sudo su - -c "R -e \"install.packages('NMF', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('joey711/phyloseq')\""
sudo su - -c "R -e \"install.packages('gridExtra', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('ggplot2', repos = 'http://cran.rstudio.com/')\""

sudo install -y python-pip
pip install --upgrade pip
pip install cwlref-runner

sudo apt-get install nodejs

wget http://drive5.com/python/python_scripts.tar.gz
sudo tar zxvf python_scripts.tar.gz -C /usr/local/bin/

rm fasta-splitter-0.2.4.zip
rm fastqc_v0.11.5.zip
rm fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
rm Miniconda3-latest-Linux-x86_64.sh
