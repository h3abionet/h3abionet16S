# h3abionet16S analysis package

Below is a desciption of what you would find in each folder of the repository

**[automation](https://github.com/h3abionet/h3abionet16S/tree/master/automation)** - Scripts and info on setting up an OpenStack VM, setting up the necessary docker files and running a CWL workflow.

**[dockerfiles](https://github.com/h3abionet/h3abionet16S/tree/master/dockerfiles)** - docker build files for QC, UPARSE, QIIME, in house scripts and R setup

**[example](https://github.com/h3abionet/h3abionet16S/tree/master/example)** - Information and supporting files needed to run the workflow on a host OS or through docker containers.

**[workflows](https://github.com/h3abionet/h3abionet16S/tree/master/workflows)** - CWL workflows for running the 16S pipeline on a machine setup with the necessary software or a machine with the necessart docker containers.

**[helpers](https://github.com/h3abionet/h3abionet16S/tree/master/helpers)** - Helper scripts and code.

The project is still in development and needs work in parts of the design, code, documentation and testing. The current status of our workflow is shown in the diagram below:

![workflow](https://raw.githubusercontent.com/h3abionet/h3abionet16S/master/h3abionet16S_CWL_workflow.png "CWL workflow")

