#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: h3abionet_org/h3a16s-usearch

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

baseCommand: [ usearch ]

arguments:
  - valueFrom: $(inputs.sampleName)_merged.fastq
    prefix: "-fastqout"

outputs:
  mergedFastQ:
    type: File
    outputBinding:
      glob: $(inputs.sampleName)_merged.fastq
