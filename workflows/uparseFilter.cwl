#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: h3abionet_org/h3a16s-usearch

inputs:
  fastqFile:
    type: File
    inputBinding:
      prefix: "-fastq_filter"
  fastqMaxEe:
    type: float
    inputBinding:
      prefix: "-fastq_maxee"

baseCommand: [ usearch, "-fastaout", filtered.fasta ]

outputs:
  filteredFasta:
    type: File
    outputBinding:
      glob: filtered.fasta
