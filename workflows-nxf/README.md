# Running with Nextflow

## Setup

### On your local system

1) Build the docker containers fastqc, in-house, qiime and usearch:

#### fastqc
```bash
cd dockerfiles/fastqc/
docker build --tag h3abionet_org/h3a16s-fastqc .
```

#### in-house
```bash
cd dockerfiles/in-house/
docker build --tag h3abionet_org/h3a16s-in-house .
```

#### qiime
```bash
cd dockerfiles/qiime/
docker build --tag h3abionet_org/h3a16s-qiime .
```

#### usearch
Make a request here: http://www.drive5.com/usearch/download.html . Once you've agreed to the license Robert Edgar will send you an email with a link where you can download the binary from.

```
cd dockerfiles/usearch
wget http://link_in_email -O usearch
docker build --tag h3abionet_org/h3a16s-usearch .
```

2) Then build the singularity containter from there (see how it is done [here](https://github.com/singularityware/docker2singularity))

#### fastqc
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-fastqc
```

#### in-house
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-in-house
```

#### qiime
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-qiime
```

#### usearch
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-usearch
```

3) Copy the container over to Hex.

### On Hex

1) Change your `nextflow.config` to point to the specific singularity container.

2) Run the pipeline

```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.hex /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile hex
```

### On your local system
```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.local /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile local
```

### Workflow diagram

![workflow](https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/workflows-nxf/h3abionet16S_NXF_workflow.png "Nextflow workflow")

### Run output

See the example of output files on a run of two samples.

```bash
nextflow-output/otu_picking
├── no_chimera.fasta
├── otus_raw.fasta
├── otus_renamed.fasta
├── otus_table.biom
├── otus.uc
└── otu-table.txt
nextflow-output/otu_processing
├── filtered_alignment
│   └── otus_renamed_aligned_pfiltered.fasta
├── otus.align
│   └── otus_renamed_aligned.fasta
├── otus_table.tax.biom
├── otus.tre
└── tax
    └── otus_renamed_tax_assignments.txt
nextflow-output/qc
├── filtered
│   ├── Dog1
│   │   └── Dog1_fastqc
│   │       └── Dog1_filtered_fastqc.zip
│   ├── Dog10
│   │   └── Dog10_fastqc
│   │       └── Dog10_filtered_fastqc.zip
│   └── multiqc_report.html
└── raw
    ├── Dog1
    │   └── Dog1_fastqc
    │       ├── Dog1_R1_fastqc.zip
    │       └── Dog1_R2_fastqc.zip
    ├── Dog10
    │   └── Dog10_fastqc
    │       ├── Dog10_R1_fastqc.zip
    │       └── Dog10_R2_fastqc.zip
    └── multiqc_report.html
nextflow-output/raw
└── qc
    └── multiqc_report.html
nextflow-output/read_processing
├── concat.fasta
├── derep.fasta
├── Dog1
│   ├── Dog1_filtered.fasta
│   ├── Dog1_filtered.fastq
│   ├── Dog1_filtered_stripped_primers.fasta
│   ├── Dog1_filtered_stripped_primers.log
│   ├── Dog1_filtered_stripped_primers_truncated.fasta
│   ├── Dog1_forward_renamed.fastq
│   ├── Dog1_merged.fastq
│   └── Dog1_reverse_renamed.fastq
├── Dog10
│   ├── Dog10_filtered.fasta
│   ├── Dog10_filtered.fastq
│   ├── Dog10_filtered_stripped_primers.fasta
│   ├── Dog10_filtered_stripped_primers.log
│   ├── Dog10_filtered_stripped_primers_truncated.fasta
│   ├── Dog10_forward_renamed.fastq
│   ├── Dog10_merged.fastq
│   └── Dog10_reverse_renamed.fastq
└── sorted.fasta
nextflow-output/summaries
├── otus.summary.observations
└── otus.summary.qualitative
```

* The output folders are divided in `qc`, `read_processing`, `otu_picking`, `otu_processing` and `summaries`
* The MultiQC reports would be of interest before and after filtering
* The `otus_table.tax.biom` and `otus.tre` can be pulled into R for further analysis.
* The files in `summaries` gives overall sample/OTU abundances.
