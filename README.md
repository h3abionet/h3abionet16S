# h3abionet16S 16S rDNA analysis package

We have developed an integrated software package that combines together all the steps required in the 16S analysis. It takes raw 16S rDNA reads quality controls them, creates OTUs, does OTU classification and generates a phylogenetic tree of the OTU sequences. The output is a `.biom` file and a Newick `.tre` file that can be pulled into R for further analysis. The package is wrapped into a Nextflow pipeline which is accompanied by a configuration file whereby read processing parameters and classification database can be predefined. The resulting pipeline uses FastQC and MultiQC for QC reporting, usearch for reading QC, merging and OTU picking, and QIIME for classification and phylogenetic tree generation. The whole workflow is packaged in Singularity containers and this makes it portable to any system that has Singularity setup. 

Two workflow languages were investigated  for running this pipeline. CWL and Nextflow.

To access the CWL workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-cwl) (runs on Docker containers or a locally software installed setup)

To access the Nexftlow  workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-nxf) (runs on Singularity containers)

**The Nexflow workflow is the most updated version of the pipeline and for now the recommended to use.**

**Todos** - please let us know if you want to help on any of this.
* Get `usearch` replaced with `vsearch`. This will make containerisation and distribution much easier. `usearch` is currently license and `vsearch` not. We have have done comparisons locally and `vsearch` performs just as well.
* Work on the current Nextflow pipeline. Some steps need different resource requirements. At the moment changes the resource requirements affects all process which is unnecessary.
* Include some unit testing with e.g. Travis CI. We have test and resulting output data.
* Give the options to create Singularity containers directly from a Docker repos (Quay.io). We tested this at the end of 2017 and at that time it did not work but from the recent Nextflow documentation it should be sorted out now.
* Get the CWL pipeline at the same stage as the current Nextflow pipeline. Get it running with Toil so that we can parallelise jobs. Once the CWL version is updated we can do not think it would be much work to get the pipeline setup in Galaxy.


