#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: h3abionet_org/h3a16s-usearch

inputs:
  fastaFile:
    type: File
    inputBinding:
      prefix: "-cluster_otus"
  otuRadiusPct:
    type: float
    inputBinding:
      prefix: "-otu_radius_pct"

baseCommand: [ usearch,  "-otus", otus_raw.fasta ]

outputs:
  otuFasta:
    type: File
    outputBinding:
      glob: otus_raw.fasta
