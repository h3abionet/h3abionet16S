# nextflow branch

This branch contains the code to get the pipeline up and running on a local system and the Hex cluster using nextflow and singularity. The initial work will only focus on getting things running on Hex, but things will later be adapted to other environments and setups. The plan is also to include some kind of continuous integration needs to be worked in as well.

The pipeline is currently setup to run until MakePhylogeny and AddMetadata. Things are still in progress.

## Setup

### On your local system

1) Build the docker containters e.g:

```bash
docker build --tag h3abionet_org/h3a16s-in-house .
```

2) Then build the singularity containter from there (see how it is done [here](https://github.com/singularityware/docker2singularity))
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /home/gerrit/scratch/h3abionet16S/singularity-containers/:/output --privileged -t --rm singularityware/docker2singularity h3abionet_org/h3a16s-in-house
```

3) Copy the container over to Hex.

### On Hex

1) Change your `nextflow.config` to point to the specific singularity container.

2) Run the pipeline

```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.hex /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile pbs
```

### On your local system
```bash
nextflow -log nextflow.log run -w /researchdata/fhgfs/gerrit/h3abionet16S/nextflow-workdir -c /home/gerrit/code/h3abionet16S/workflows-nf/nextflow.config.local /home/gerrit/code/h3abionet16S/workflows-nf/main.nf -profile local
```
