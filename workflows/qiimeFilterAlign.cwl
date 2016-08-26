#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusRepsetAlignedFasta:
    type: File
    inputBinding:
      prefix: "-i"
baseCommand: [ filter_alignment.py, "-o", filtered_alignment ]

outputs:
  filteredAligned:
    type: Directory
    outputBinding:
      glob: .


#filter_alignment.py -i rep_set_align/61_otus_aligned.fasta -o filtered_alignment
