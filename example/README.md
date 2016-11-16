# Setting up machine to run worklow on docker contatainers (tested on Ubuntu 16.04.1)

## Update OS

```
sudo apt-get update
sudo apt-get -y upgrade
```

## Setup docker

### Based on these instructions: https://docs.docker.com/engine/installation/linux/ubuntulinux/

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-cache policy docker-engine
sudo apt-get install docker-engine
sudo service docker start
```

# Optional - Add your username to the docker group to be able to run containers. Do a small test to check if calling a container works.
```
sudo adduser user
sudo adduser user docker
su user
docker run hello-world
```

## Setup CWL
```
sudo apt-get install python-pip
sudo apt-get install libpython-dev
sudo pip install cwltool
sudo apt-get install nodejs
```
## Clone h3abionet16S repos
```
cd /home/user/
git clone https://github.com/h3abionet/h3abionet16S.git
```

## Build containers
### FastQC, QIIME, in-house and R with modules
```
cd /home/user/h3abionet16S/dockerfiles/
docker build --tag longyee/fastqc fastqc/
docker build --tag longyee/qiime qiime/
docker build --tag longyee/r r/
docker build --tag longyee/in-house in-house/
```
### USEARCH
Make a request here: http://www.drive5.com/usearch/download.html . Once you've agreed to the license you, Robert Edgar will send you an email with a link where you can download the binary from.

```
cd /home/user/h3abionet16S/dockerfiles/usearch
wget http://link_in_email -O usearch
docker build --tag longyee/usearch .
```

## Get some test data and link it properly.

### Get test and reference data

#### Get test data
```
sudo mkdir -p /scratch/user
sudo chown -R user /scratch/user/
cd /scratch/user
mkdir h3abionet16S
mkdir h3abionet16S/dog_stool_samples
cd h3abionet16S/dog_stool_samples
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog{1..31}_R{1..2}.fastq
```
#### Get reference data
```
cd /scratch/user/h3abionet16S
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
tar -xzvf gg_13_8_otus.tar.gz
mkdir chimera_checking_db
cd chimera_checking_db
wget http://drive5.com/uchime/gold.fa
```

### Do linking
```
cd /home/user/h3abionet16S/example
ln -s /scratch/user/h3abionet16S/dog_stool_samples/ .
ln -s /scratch/user/h3abionet16S/greengenes/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt .
ln -s /scratch/user/h3abionet16S/greengenes/gg_13_8_otus/rep_set/97_otus.fasta .
ln -s /scratch/user/h3abionet16S/greengenes/gg_13_8_otus/rep_set_aligned/97_otus.fasta 97_otus.pynast.fasta
ln -s /scratch/user/h3abionet16S/chimera_checking_db/gold.fa .
```

## Now run the example data through the complete workflow
```
mkdir /scratch/user/h3abionet16S/workflow_output
mkdir /scratch/user/h3abionet16S/cachedir
cwltool --cachedir /scratch/user/h3abionet16S/cachedir/cache --outdir /scratch/user/h3abionet16S/workflow_output /home/user/h3abionet16S/workflows-docker/completeWorkflow-docker.cwl /home/user/h3abionet16S/example/input.yml 
```

## Input
* ```input.yml``` - Example input file containing tool configuration options, paths to references databases and sample info of the dog stool samples. ```../helpers/metadata_to_cwl_yml.sh``` was used to generate the sample info in ```input.yml``` from ```dog_stool_samples_metadata.tsv```. 
* ```dog_stool_samples_metadata.tsv``` - Metadata/mapping file. Used for generating R reports. At some point this needs to be passed directly from ```input.yml```.


## Output
On a successful run you would find the following files and directories in your output folder
* ```*_fastqc``` directories contain FastQC reports per sample. There is also plans to combine all the reports into a single FastQC summary page later.
* ```*_forward_rename.fastq```,  ```*_reverse_rename.fastq``` - fastq files renamed for compatibility with UPARSE.
* ```*_merged.fastq``` - per sample merged fastq files.
* ```filtered.fasta``` -  This would be the file for the last sample run through filtering. Not usefull.
* ```derep.fasta``` - dereplicated fasta set.
* ```sorted.fasta``` - dereplicated fasta set sorted based on duplication level of the sequence.
* ```otus_raw.fasta``` - representitave sequences for OTUs.
* ```no_chimera.fasta``` - chimera reads removed from ```otus_raw.fasta```
* ```otus_renamed.fasta``` - ```no_chimera.fasta``` fasta headers renamed to OTU_1, OTU_2, OTU_... . This is done for compatibility downstream.
* ```concat.fasta``` - filtered reads (from each sample, but with barcode info to keep identity) combined into one fasta file.
* ```otus.uc``` - UPARSE formatted OTU table.
* ```otus.table``` - OTU table.
* ```otus_renamed_tax_assignment.txt``` - OTU table with taxonomy information.
* ```otus.tax.biom``` - OTU table in BIOM format.
* ```otus.summary.qualitative``` - number of OTUs per sample.
* ```otus.summary.observations``` - number of merged reads per OTU.
* ```otus.shared_phylotypes``` - to be added.   
* ```otus_renamed_aligned.fasta``` - Aligned OTU sequences against a pre-aligned database.
* ```otus_renamed_aligned_pfiltered.fasta``` - Removes gaps in ```otus_renamed_aligned.fasta```
* ```otus.tre``` - Phylogenetic tree build from the filtered alignment.
* ```barplot.jpg``` - Composition breakdown for each sample. 
* ```heatmap.jpg``` - OTU abundance per sample.
* ```richness.jpg``` - Richness plots for several metrics.
* ```ordination.jpg``` - NMDS plot. Need to work on this.

# Setting up machine to run worklow on on Ubuntu 16.04.1

## Update OS

```
sudo apt-get update
sudo apt-get -y upgrade
```

## Prepare working directories
```
sudo mkdir -p /home/user
sudo mkdir -p /scratch/user
```

## Install FastQC
```
cd /scratch/user
sudo apt-get install wget unzip libfindbin-libs-perl -y
sudo apt-get install openjdk-8-jre -y
sudo wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
sudo unzip fastqc_v0.11.5.zip
sudo mv FastQC/ /opt/
sudo chmod +x /opt/FastQC/fastqc
sudo ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc
```

## Install in-house tools and dependencies
```
sudo apt-get install wget unzip bzip2 apt-utils imagemagick -y
#
sudo wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
sudo tar jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2  -C /usr/local/
#
sudo wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/rename_fastq_headers.sh
sudo chmod +x rename_fastq_headers.sh
sudo mv rename_fastq_headers.sh /usr/local/bin/
#
sudo wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_derep_workaround.sh
sudo chmod +x uparse_derep_workaround.sh
sudo mv uparse_derep_workaround.sh /usr/local/bin/
#
sudo wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/concat_fasta.sh
sudo chmod +x concat_fasta.sh
sudo mv concat_fasta.sh /usr/local/bin/
#
sudo wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/generate_R_reports.R
sudo chmod +x generate_R_reports.R
mv generate_R_reports.R /usr/local/bin/
#
sudo apt-get install -y wget unzip bzip2 sudo libfile-util-perl
sudo wget http://kirill-kryukov.com/study/tools/fasta-splitter/files/fasta-splitter-0.2.4.zip
sudo unzip fasta-splitter-0.2.4.zip
sudo chmod +x fasta-splitter.pl
sudo mv fasta-splitter.pl /usr/local/bin/
#
sudo wget https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/helpers/uparse_global_search_workaround.sh
sudo chmod +x uparse_global_search_workaround.sh
sudo mv uparse_global_search_workaround.sh /usr/local/bin/
```

## Install QIIME
```
sudo apt-get install -y wget bzip2 libxext6 libsm6 libxrender1

# Ref: http://qiime.org/install/install.html
# Based on https://hub.docker.com/r/continuumio/miniconda/~/dockerfile/
sudo sh -c "echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh" && \
sudo wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
sudo /bin/bash ~/miniconda.sh -b -p /opt/conda && \ 
sudo rm ~/miniconda.sh
export PATH=/opt/conda/bin:$PATH
sudo /opt/conda/bin/conda create -y -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
sudo /opt/conda/bin/conda install -y psutil
export PATH=/opt/conda/envs/qiime1/bin:$PATH
```

## Install R and modules
```
sudo apt-get install -y wget
# Install R
# Ref: https://www.datascienceriot.com/how-to-install-r-in-linux-ubuntu-16-04-xenial-xerus/kris/
sudo sh -c "echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list"
sudo gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
sudo gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install r-base r-base-dev
sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"source('https://bioconductor.org/biocLite.R')\""
sudo su - -c "R -e \"install.packages('NMF', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('joey711/phyloseq')\""
sudo su - -c "R -e \"install.packages('gridExtra', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('ggplot2', repos = 'http://cran.rstudio.com/')\""
```

## Install USEARCH
Make a request here: http://www.drive5.com/usearch/download.html . Once you've agreed to the license you, Robert Edgar will send you an email with a link where you can download the binary from.

```
wget http://link_in_email -O usearch
sudo chmod +x usearch
sudo mv usearch /usr/local/bin/
```
## Install USEARCH support scripts
```
sudo wget http://drive5.com/python/python_scripts.tar.gz
sudo tar zxvf python_scripts.tar.gz -C /usr/local/bin/
```

## Install cwltool (something might become messy here later because we are using the python conda version for QIIME and the local python for cwltool setup)
```
sudo apt-get install python-pip -y
sudo apt-get install libpython-dev -y
sudo /usr/bin/pip install cwltool
sudo apt-get install nodejs -y
```

## Get code
```
cd /home/user
sudo git clone https://github.com/h3abionet/h3abionet16S.git
```

## Get reference data and linking
Do the same setup as was done with setup running on docker containers.

## Running
The QIIME environment needs to be activated and we are calling ```completeWorkflow.cwl``` instead of```completeWorkflow-docker.cwl```.
```
source activate qiime1
cwltool --cachedir /scratch/user/h3abionet16S/cachedir/cache --outdir /scratch/user/h3abionet16S/workflow_output /home/user/h3abionet16S/workflows-docker/completeWorkflow.cwl /home/user/h3abionet16S/example/input.yml
```
