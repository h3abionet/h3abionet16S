#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  fastqFile:
    type: File
    inputBinding:
      prefix: "-fastq_filter"
baseCommand: [ usearch8, "-fastq_maxee", "0.1", "-fastaout", filtered_1.fasta ]

outputs:
  filteredFasta:
    type: File
    outputBinding:
      glob: filtered_1.fasta



#usearch8 -fastq_filter merge_renamed.fastq -fastq_maxee 0.1 -fastaout filtered_1.fasta
