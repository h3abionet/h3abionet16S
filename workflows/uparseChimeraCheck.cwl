#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: h3abionet_org/h3a16s-usearch

inputs:
  fastaFile:
    type: File
    inputBinding:
      prefix: "-uchime2_ref"
  chimeraFastaDb:
    type: File
    inputBinding:
      prefix: "-db"
  strandInfo:
    type: string
    inputBinding:
      prefix: "-strand"
  chimeraCheckMode:
    type: string
    inputBinding:
      prefix: "-mode"

baseCommand: [ usearch,  "-notmatched", no_chimera.fasta ]

outputs:
  chimeraCleanFasta:
    type: File
    outputBinding:
      glob: no_chimera.fasta
