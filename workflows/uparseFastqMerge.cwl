#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  fastqFileF:
    type: File
    inputBinding:
      prefix: "-fastq_mergepairs"
  fastqFileR:
    type: File
    inputBinding:
      prefix: "-reverse"
baseCommand: [ usearch8, "-fastq_maxdiffs", "25", "-fastqout", mergedFastQ.fastq ]

outputs:
  mergedFastQ:
    type: File
    outputBinding:
      glob: mergedFastQ.fastq
