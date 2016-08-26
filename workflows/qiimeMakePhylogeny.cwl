#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusAlignedFilteredFasta:
    type: File
    inputBinding:
      prefix: "-i"
baseCommand: [ make_phylogeny.py, "-o", otus_repsetOUT_aligned_pfiltered.tre ]

outputs:
  otusAlignedfilteredTree:
    type: File
    outputBinding:
      glob: otus_repsetOUT_aligned_pfiltered.tre


# make_phylogeny.py -i filtered_alignment/61_otus_aligned_pfiltered.fasta
# -o filtered_alignment/otus_repsetOUT_aligned_pfiltered.tre
