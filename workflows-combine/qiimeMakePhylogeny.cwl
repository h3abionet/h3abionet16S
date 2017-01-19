#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: longyee/qiime

inputs:
  otuFasta:
    type: File
    inputBinding:
      prefix: "-i"
baseCommand: [ make_phylogeny.py, "-o", otus.tre ]

outputs:
  otuTree:
    type: File
    outputBinding:
      glob: otus.tre

# make_phylogeny.py -i filtered_alignment/61_otus_aligned_pfiltered.fasta
# -o filtered_alignment/otus_repsetOUT_aligned_pfiltered.tre
