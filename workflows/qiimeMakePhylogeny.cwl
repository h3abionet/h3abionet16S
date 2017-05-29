#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: quay.io/h3abionet_org/h3a16s-qiime

inputs:
  otuFasta:
    type: File
    inputBinding:
      prefix: "-i"
baseCommand: [ make_phylogeny.py, "-o", otus.tre ]

outputs:
  otuTree:
    type: File
    outputBinding:
      glob: otus.tre
