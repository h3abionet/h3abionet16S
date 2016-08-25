#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  filteredFastaFile:
    type: File
    inputBinding:
      prefix: "-sortbysize"
  minSize:
    type: int
    inputBinding:
      prefix: "-minsize"
baseCommand: [ usearch8,  "-fastaout", filtered_sorted.fasta ]

outputs:
  filteredSortedFasta:
    type: File
    outputBinding:
      glob: filtered_sorted.fasta



#usearch8 -sortbysize filtered_1.fasta -fastaout filtered_sorted.fasta -minsize 2
