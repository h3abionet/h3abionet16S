#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: quay.io/longyee/in-house

inputs:
  fastaFiles:
    type: File[]
    inputBinding:
      position: 1

baseCommand: [ concat_fasta.sh ]

outputs:
  concatFasta:
    type: File
    outputBinding:
      glob: concat.fasta
