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
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.hex /home/gerrit/code/h3abionet16S/workflows-nxf/main.nf -profile hex
```
## Setup to run on Hex/PBS cluster

Use the same procedure to build the singularity conaineters for a local machine.

### On your local system
```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.local /home/gerrit/code/h3abionet16S/workflows-nxf/main.nf -profile local
```

### Workflow diagram

![workflow](https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/workflows-nxf/h3abionet16S_NXF_workflow.png "Nextflow workflow")


### Running on own data

#### Input files

1. Raw reads need to be of the format `S1_R1.fastq` and `S1_R2.fastq` and all reads needs to be in one directory e.g.

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

### Suggested setup process for users running projects on Hex

1. create a project directory e.g. `/researchdata/fhgfs/gerrit/test-project`

2. `cd /researchdata/fhgfs/gerrit/test-project`

3. clone repos 

`git clone https://github.com/h3abionet/h3abionet16S.git`

4. Now there should be an extra directory in your project dir
```bash
pwd
/researchdata/fhgfs/gerrit/test-project
ls
h3abionet16S
```
5. Copy hex exmple to base of your root directory
```bash
cp h3abionet16S/workflows-nxf/nextflow.config.hex nextflow.config
ls
h3abionet16S  nextflow.config
```

6. Edit `nextflow.config`

Change

`rawReads` to were your raw data is
`rawReads = "/researchdata/fhgfs/gerrit/h3abionet16S/dog_stool_two_samples_only"`

`qiimeMappingFile`. For the dogstool samples there is a mapping file in the github repos under example/
 `qiimeMappingFile = "/researchdata/fhgfs/gerrit/test-project/h3abionet16S/example"`

`outDir` change to where your project dir is e.g
 `outDir = "/researchdata/fhgfs/gerrit/test-project/nextflow-output"`

Then look at the per tool flag settings and see if you are happy with them or if they need to change.

Also look at the Hex profile settings at the end. Change the email address to yours.

7. To run. Rrun in base of project dir. All nextflow cache and logs are created in there. 

```nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/test-project/nextflow-workdir -c nextflow.config /researchdata/fhgfs/gerrit/test-project/h3abionet16S/workflows-nxf/main.nf -profile hex```

8. When you want resume if some downstream step has failed but you do not want to rerun the upstream steps. You need need to be in the project directory and add the `-resume` flag. 

`nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/test-project/nextflow-workdir -c nextflow.config /researchdata/fhgfs/gerrit/test-project/h3abionet16S/workflows-nxf/main.nf -profile hex -resume`

9. Once your run is done archive the output data, `nextflow.config`, github code and ideally the singularity containers. Also note the version of Nextflow used for the run.
 
