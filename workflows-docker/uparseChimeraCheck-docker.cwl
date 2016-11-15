#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/usearch

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
