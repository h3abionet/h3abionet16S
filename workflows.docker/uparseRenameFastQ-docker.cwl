#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/house

inputs:
  sampleName:
    type: string
    inputBinding:
      position: 1
  fastqFileF:
    type: File
    inputBinding:
      position: 2
  fastqFileR:
    type: File
    inputBinding:
      position: 3

baseCommand: [ rename_fastq_headers.sh ]

arguments:
  - valueFrom: forward.fastq
    position: 4
  - valueFrom: reverse.fastq
    position: 5

outputs:
  forwardRename:
    type: File
    outputBinding:
      glob: forward.fastq
  reverseRename:
    type: File
    outputBinding:
      glob: reverse.fastq
