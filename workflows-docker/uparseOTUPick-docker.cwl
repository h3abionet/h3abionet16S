#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/usearch

inputs:
  fastaFile:
    type: File
    inputBinding:
      prefix: "-cluster_otus"
  otuRadiusPct:
    type: float
    inputBinding:
      prefix: "-otu_radius_pct"

#baseCommand: [ usearch8,  "-otus", otus_raw.fasta ]
baseCommand: [ "-otus", otus_raw.fasta ]

outputs:
  otuFasta:
    type: File
    outputBinding:
      glob: otus_raw.fasta

#usearch8 -cluster_otus filtered_sorted.fasta -otu_radius_pct 3.0 -otus otus_raw.fa
