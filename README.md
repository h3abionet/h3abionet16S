# h3abionet16S analysis package

Below is a desciption of what you would find in each folder of the repository

**docker** - docker build files for QC, UPARSE, QIIME and R setup

**workflows** - CWL workflows for running the 16S pipeline on a VM setup with the necessary software.

**workflows-docker** - CWL workflows for the 16S pipeline to run on the Docker containers.

**automation** - Scripts and info on setting up an OpenStack VM, setting up the necessary docker files and running a CWL workflow.

**example** - Information and supporting files needed to run the workflow on a host OS or through docker containers.

The project is still in development and needs work in various parts of the design, code, documentation and testing. The current status of our workflow is however shown in the diagram below:

![workflow](https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/h3abionet16S_CWL_workflow.png "CWL workflow")

