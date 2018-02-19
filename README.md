# h3abionet16S 16S rDNA analysis package

We have developed an integrated software package that combines together all the steps required in the 16S analysis. It takes raw 16S rDNA reads quality controls them, creates OTUs, does OTU classification and generates a phylogenetic tree of the OTU sequences. The output is a `.biom` file and a Newick `.tre` file that can be pulled into R for further analysis. The package is wrapped into a Nextflow pipeline which is accompanied by a configuration file whereby read processing parameters and classification database can be predefined. The resulting pipeline uses FastQC and MultiQC for QC reporting, usearch for reading QC, merging and OTU picking, and QIIME for classification and phylogenetic tree generation. The whole workflow is packaged in Singularity containers and this makes it portable to any system that has Singularity setup. 

Two workflow languages were investigated  for running this pipeline. CWL and Nextflow.

To access the CWL workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-cwl) (Runs on Docker containers or a locally installed setup.)

To access the Nexftlow  workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-nxf) (Runs on Singularity containters)

**The Nexflow workflow is the most updated version of the pipeline and for now the recommended to use.**
