#!/bin/bash
############################################################
# Run workflows
############################################################

cd ~/h3abionet16S/workflows-docker
ln -s /home/ubuntu/input/dog_stool_samples/ .
cwltool --outdir ~/output demo-docker.cwl demo-docker.input.yml
