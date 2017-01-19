#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: longyee/usearch

inputs:
  fastaFile:
    type: File
    inputBinding:
      prefix: "-sortbysize"
  minSize:
    type: int
    inputBinding:
      prefix: "-minsize"

baseCommand: [ usearch,  "-fastaout", sorted.fasta ]

outputs:
  sortedFasta:
    type: File
    outputBinding:
      glob: sorted.fasta
