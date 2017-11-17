# Running with Nextflow

## Setup to run on Hex/PBS cluster

### On your local system

#### 1. Build the docker containers fastqc, in-house, qiime and usearch:

##### fastqc
```bash
cd dockerfiles/fastqc/
docker build --tag h3abionet_org/h3a16s-fastqc .
```

##### in-house
```bash
cd dockerfiles/in-house/
docker build --tag h3abionet_org/h3a16s-in-house .
```

##### qiime
```bash
cd dockerfiles/qiime/
docker build --tag h3abionet_org/h3a16s-qiime .
```

##### Note the fastqc, in-house and qiime docker containers can also be pulled from quay.io
```bash
docker pull quay.io/h3abionet_org/h3a16s-fastqc
docker pull quay.io/h3abionet_org/h3a16s-in-house
docker pull quay.io/h3abionet_org/h3a16s-qiime
```

##### usearch
Make a request here: http://www.drive5.com/usearch/download.html . Once you've agreed to the license Robert Edgar will send you an email with a link where you can download the binary from.

```
cd dockerfiles/usearch
wget http://link_in_email -O usearch
docker build --tag h3abionet_org/h3a16s-usearch .
```

#### 2. Then build the singularity containter from there (see how it is done [here](https://github.com/singularityware/docker2singularity))

##### fastqc
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-fastqc
```

##### in-house
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-in-house
```

##### qiime
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-qiime
```

##### usearch
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-usearch
```

#### 3 Copy the singulariy containers over to Hex.

### On Hex

#### 1. Change your `nextflow.config` to point to the specific singularity container.

#### 2. Run the pipeline

```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.hex /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile hex
```
## Setup to run on Hex/PBS cluster

Use the same procedure to build the singularity conaineters for a local machine.

### On your local system
```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.local /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile local
```

### Workflow diagram

![workflow](https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/workflows-nxf/h3abionet16S_NXF_workflow.png "Nextflow workflow")


### Running on own data

#### Input files

1. Raw reads need to be of the format `S1_R1.fastq.gz` and `S1_R2.fastq.gz` and all reads needs to be in one directory e.g.

```bash
ls -1 dog_stool_samples
Dog10_R1.fastq
Dog10_R2.fastq
Dog15_R1.fastq
Dog15_R2.fastq
Dog16_R1.fastq
Dog16_R2.fastq
Dog17_R1.fastq
Dog17_R2.fastq
Dog1_R1.fastq
Dog1_R2.fastq
Dog22_R1.fastq
Dog22_R2.fastq
Dog23_R1.fastq
Dog23_R2.fastq
Dog24_R1.fastq
Dog24_R2.fastq
Dog29_R1.fastq
Dog29_R2.fastq
Dog2_R1.fastq
Dog2_R2.fastq
Dog30_R1.fastq
Dog30_R2.fastq
Dog31_R1.fastq
Dog31_R2.fastq
Dog3_R1.fastq
Dog3_R2.fastq
Dog8_R1.fastq
Dog8_R2.fastq
Dog9_R1.fastq
Dog9_R2.fastq

```

2. QIIME metadata file (at the moment this is only used to trim primers). See an example [here]( https://github.com/h3abionet/h3abionet16S/blob/master/example/dog_stool_samples_metadata.tsv)

#### To change in nextflow.config

1. Change the projectName. Keep it short.

2. Change the path of the rawReads directory.

3. Change the path to the qiimeMappingFile.

4. Change the path to the outDir directory.

5. Base on your data and analysis change other pipeline configuration settings.

6. Change path to singularity containers. If you are working on Hex do not worry about this and just use what is in `nextflow.config.hex`.

### Run output

See the example of output files on a run of two samples.

```bash
nextflow-output/
├── otu_picking
│   ├── no_chimera.fasta
│   ├── otus_raw.fasta
│   ├── otus_renamed.fasta
│   ├── otus_table.biom
│   ├── otus.uc
│   └── otu-table.txt
├── otu_processing
│   ├── filtered_alignment
│   │   └── otus_renamed_aligned_pfiltered.fasta
│   ├── otus.align
│   │   └── otus_renamed_aligned.fasta
│   ├── otus_table.tax.biom
│   ├── otus.tre
│   └── tax
│       └── otus_renamed_tax_assignments.txt
├── qc
│   ├── filtered
│   │   ├── Dog1
│   │   │   └── Dog1_fastqc
│   │   │       └── Dog1_filtered_fastqc.zip
│   │   ├── Dog10
│   │   │   └── Dog10_fastqc
│   │   │       └── Dog10_filtered_fastqc.zip
│   │   └── multiqc_report.html
│   └── raw
│       ├── Dog1
│       │   └── Dog1_fastqc
│       │       ├── Dog1_R1_fastqc.zip
│       │       └── Dog1_R2_fastqc.zip
│       ├── Dog10
│       │   └── Dog10_fastqc
│       │       ├── Dog10_R1_fastqc.zip
│       │       └── Dog10_R2_fastqc.zip
│       └── multiqc_report.html
├── read_processing
│   ├── concat.fasta
│   ├── derep.fasta
│   ├── Dog1
│   │   ├── Dog1_filtered.fasta
│   │   ├── Dog1_filtered.fastq
│   │   ├── Dog1_filtered_stripped_primers.fasta
│   │   ├── Dog1_filtered_stripped_primers.log
│   │   ├── Dog1_filtered_stripped_primers_truncated.fasta
│   │   ├── Dog1_forward_renamed.fastq
│   │   ├── Dog1_merged.fastq
│   │   └── Dog1_reverse_renamed.fastq
│   ├── Dog10
│   │   ├── Dog10_filtered.fasta
│   │   ├── Dog10_filtered.fastq
│   │   ├── Dog10_filtered_stripped_primers.fasta
│   │   ├── Dog10_filtered_stripped_primers.log
│   │   ├── Dog10_filtered_stripped_primers_truncated.fasta
│   │   ├── Dog10_forward_renamed.fastq
│   │   ├── Dog10_merged.fastq
│   │   └── Dog10_reverse_renamed.fastq
│   └── sorted.fasta
└── summaries
    ├── summary.otu_read_count.txt
    ├── summary.sample_otu_count.txt
    └── summary.sample_read_count.txt
```

* The output folders are divided in `qc`, `read_processing`, `otu_picking`, `otu_processing` and `summaries`
* The MultiQC reports would be of interest before and after filtering
* The `otus_table.tax.biom` and `otus.tre` can be pulled into R for further analysis.
* The files in `summaries` gives overall sample/OTU/read counts.

An example out of a run on 15 samples can be viewed [here](http://web.cbio.uct.ac.za/~gerrit/examples/nextflow/dog_stool_samples) 

