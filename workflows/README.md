Our pipeline specefic CWL workflows will be added here. Will push it to the public CWL repos once ready and acceptable.

Current dependencies that need to be installed and set in your PATH to successfully run the current workflows in this folder.

* http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
* http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
* http://www.drive5.com/usearch/download.html

The dataset that we are currently use for testing is publically available here: http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/

Step 1: Running fastqc over a single filenames

usage: fastqc.cwl [-h] --fastqFile FASTQFILE [job_order]


optional arguments:

-h, --help            show this help message and exit

--fastqFile FASTQFILE


Step 2: Running fastqc over a multiple filenames

usage: multipleFastqc.cwl [-h] --fastqSeqs FASTQSEQS [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastqSeqs FASTQSEQS

Step 3: Running uparse rename

usage: uparseRenameFastQ.cwl [-h] --fastqFileF FASTQFILEF --fastqFileR
                             FASTQFILER --sampleName SAMPLENAME
                             [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastqFileF FASTQFILEF

--fastqFileR FASTQFILER

--sampleName SAMPLENAME

Note: We only rename the headers in the fastq files

Step 4: uparse fastq merge

usage: uparseFastqMerge.cwl [-h] --fastqFileF FASTQFILEF --fastqFileR
                            FASTQFILER --fastqMaxdiffs FASTQMAXDIFFS
                            --sampleName SAMPLENAME
                            [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastqFileF FASTQFILEF

--fastqFileR FASTQFILER

--fastqMaxdiffs FASTQMAXDIFFS

--sampleName SAMPLENAME

Note: It merges reverse and forward fastq files into a a single filenames

Step 4: uparse filter

usage: uparseFilter.cwl [-h] --fastqFile FASTQFILE --fastqMaxEe FASTQMAXEE
                        [job_order]


optional arguments:

-h, --help            show this help message and exit

--fastqFile FASTQFILE

--fastqMaxEe FASTQMAXEE


Note: It filters on maxEe value (quality score)


Step 5: uparse derep workaround

usage: uparseDerepWorkAround.cwl [-h] --fastaFiles FASTAFILES [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastaFiles FASTAFILES

Note: It de-replicates the input set

Step6: uparse sort

usage: uparseSort.cwl [-h] --filteredFastaFile FILTEREDFASTAFILE --minSize
                      MINSIZE
                      [job_order]


optional arguments:

-h, --help            show this help message and exit

--filteredFastaFile FILTEREDFASTAFILE

--minSize MINSIZE

Note: It sorts the fasta files according to the abundance of the sequences


Step7: uparse OTU pick
usage: uparseOTUPick.cwl [-h] --filteredSortedFasta FILTEREDSORTEDFASTA
                         --otuRadiusPct OTURADIUSPCT
                         [job_order]

optional arguments:

-h, --help            show this help message and exit

--filteredSortedFasta FILTEREDSORTEDFASTA

--otuRadiusPct OTURADIUSPCT

Note: It clusters the input sequences based on percentage similarity


Step8: uparse chimera
usage: uparseChimeraCheck.cwl [-h] --chimDBFasta CHIMDBFASTA --otusRawFasta
                              OTUSRAWFASTA --strandInfo STRANDINFO
                              [job_order]

optional arguments:

-h, --help            show this help message and exit

--chimDBFasta CHIMDBFASTA

--otusRawFasta OTUSRAWFASTA

--strandInfo STRANDINFO

Note: It does chimera checking


Step 9: uparse rename OTUs

usage: uparseRenameOTUs.cwl [-h] --fasta FASTA [job_order]

optional arguments:

-h, --help     show this help message and exit

--fasta FASTA

Note: It renames OTUs to a better quality for adapting it to uparse

Step 10: uparse concat Fasta

usage: concatFasta.cwl [-h] --fastaFiles FASTAFILES [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastaFiles FASTAFILES

Note: it concatenates Fasta files into a single Fasta file

Step 11: uparse global search workaround

usage: uparseGlobalSearchWorkAround.cwl [-h] --fastaFile FASTAFILE
                                        --otuFastaFile OTUFASTAFILE
                                        --otuPercentageIdentity
                                        OTUPERCENTAGEIDENTITY
                                        --usearchGlobalStrand
                                        USEARCHGLOBALSTRAND
                                        [job_order]

optional arguments:

-h, --help            show this help message and exit

--fastaFile FASTAFILE

--otuFastaFile OTUFASTAFILE

--otuPercentageIdentity OTUPERCENTAGEIDENTITY

--usearchGlobalStrand USEARCHGLOBALSTRAND

Note: It *******



Step 12: uparse OTU to tab
usage: uparseOtuToTab.cwl [-h] --otusMappedOUTFasta OTUSMAPPEDOUTFASTA
                          --pythonCommand PYTHONCOMMAND
                          [job_order]

optional arguments:

-h, --help            show this help message and exit

--otusMappedOUTFasta OTUSMAPPEDOUTFASTA

--pythonCommand PYTHONCOMMAND

Note: It converts the OTUs to tabular format

QIIME STEPS start here

Step 13: qiime OTUS to biom

usage: qiimeOtusTxt2Biom.cwl [-h] [--otuTable OTUTABLE] --otusTableTabTxt
                             OTUSTABLETABTXT
                             [job_order]

optional arguments:

-h, --help            show this help message and exit

--otuTable OTUTABLE

--otusTableTabTxt OTUSTABLETABTXT

Note: Converts OTUS tabular form to binary “BIOM”


Step 14: qiime assign taxonomy
usage: qiimeAssignTaxonomy.cwl [-h] --confVal CONFVAL --method METHOD
                               --otusInputFasta OTUSINPUTFASTA
                               --otusRepsetFasta OTUSREPSETFASTA
                               --otusTaxFasta OTUSTAXFASTA
                               [job_order]

optional arguments:

-h, --help            show this help message and exit

--confVal CONFVAL

--method METHOD

--otusInputFasta OTUSINPUTFASTA

--otusRepsetFasta OTUSREPSETFASTA

--otusTaxFasta OTUSTAXFASTA

Note: It assigns taxonomy to each OTU


Step 15: qiime add metadata

usage: qiimeAddMetadata.cwl [-h] --otusTableBiom OTUSTABLEBIOM
                            --taxAssignedTxt TAXASSIGNEDTXT
                            [job_order]

optional arguments:

-h, --help            show this help message and exit

--otusTableBiom OTUSTABLEBIOM

--taxAssignedTxt TAXASSIGNEDTXT

Note: It adds metadata to the biom file

Step 16: qiime align seqeunces

usage: qiimeAlignSeqs.cwl [-h] [--msaAlignMethod MSAALIGNMETHOD]
                          --otusAlignFasta OTUSALIGNFASTA --otusRepsetFasta
                          OTUSREPSETFASTA
                          [job_order]


optional arguments:

-h, --help            show this help message and exit

--msaAlignMethod MSAALIGNMETHOD

--otusAlignFasta OTUSALIGNFASTA

--otusRepsetFasta OTUSREPSETFASTA

Note: It performs MSA of input seqeunces to be used for phylogenetic analysis


