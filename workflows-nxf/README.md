# nextflow branch

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
