#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/house

inputs:
  fastaFiles:
    type: File[]
    inputBinding:
      position: 1

baseCommand: [ uparse_derep_workaround.sh ]

outputs:
  derepFasta:
    type: File
    outputBinding:
      glob: derep.fasta

#uparse_derep_workaround.sh fastaFiles output oneFastaFile
