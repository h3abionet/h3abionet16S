#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/usearch

inputs:
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
#baseCommand: [ usearch8, "-fastqout", mergedFastQ.fastq ]
baseCommand: [ "-fastqout", mergedFastQ.fastq ]

outputs:
  mergedFastQ:
    type: File
    outputBinding:
      glob: mergedFastQ.fastq
