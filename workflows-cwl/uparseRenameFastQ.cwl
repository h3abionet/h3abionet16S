#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: quay.io/h3abionet_org/h3a16s-in-house

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
  - valueFrom: $(inputs.sampleName)_forward_rename.fastq
    position: 4
  - valueFrom: $(inputs.sampleName)_reverse_rename.fastq
    position: 5

outputs:
  forwardRename:
    type: File
    outputBinding:
      glob: $(inputs.sampleName)_forward_rename.fastq
  reverseRename:
    type: File
    outputBinding:
      glob: $(inputs.sampleName)_reverse_rename.fastq
