#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  sampleName: string
  fastqFileF:
    type: File
    inputBinding:
      prefix: "-fastq_mergepairs"
  fastqFileR:
    type: File
    inputBinding:
      prefix: "-reverse"
  fastqMaxdiffs:
    type: int
    inputBinding:
      prefix: "-fastq_maxdiffs"
#baseCommand: [ usearch8, "-fastqout", $(inputs.sampleName)_merged.fastq ]
baseCommand: [ usearch8 ]

arguments:
  - valueFrom: -fastqout
    position: 1
  - valueFrom: $(inputs.sampleName)_merged.fastq
    position: 2

outputs:
  mergedFastQ:
    type: File
    outputBinding:
      glob: $(inputs.sampleName)_merged.fastq
