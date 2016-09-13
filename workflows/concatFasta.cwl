#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

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
