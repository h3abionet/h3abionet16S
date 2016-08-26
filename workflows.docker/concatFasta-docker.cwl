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

baseCommand: [ concat_fasta.sh, concat.fasta ]

outputs:
  singleFastaFile:
    type: File
    outputBinding:
      glob: fastaFile

