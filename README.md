# h3abionet16S analysis package

A package that takes raw 16S rRNA reads QC them, create OTUs, does OTU classification and creates an phylogenetic tree of the OTU sequences. A `.biom` file and Newick .`tre` is created that can be pulled into R for further analysis.

Two workflow languages were investigated  for running this pipeline. CWL and Nextflow.

To access the CWL workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-cwl)

To access the Nexftlow  workflow go [here](https://github.com/h3abionet/h3abionet16S/tree/master/workflows-nxf)

**The Nexflow workflow is the most updated version of the pipeline and for now the recommended to use.**
