#!/bin/bash
############################################################
# Run workflows
############################################################

cd ~/h3abionet16S/workflows-docker
ln -sf /home/ubuntu/input/dog_stool_samples/ .
/home/ubuntu/.local/bin/cwltool --outdir ~/output demo-docker.cwl demo-docker.input.yml
