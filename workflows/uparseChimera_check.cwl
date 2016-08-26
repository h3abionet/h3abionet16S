#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusRawFasta:
    type: File
    inputBinding:
      prefix: "-uchime_ref"
  chimDBFasta:
    type: File
    inputBinding:
      prefix: "-db"
  strandInfo:
    type: string
    inputBinding:
      prefix: "-strand"
baseCommand: [ usearch8,  "-nonchimeras", otus_chimOUT.fasta ]

outputs:
  chimeraOutFasta:
    type: File
    outputBinding:
      glob: otus_chimOUT.fasta

#usearch8 -uchime_ref $outDir/otus_raw.fa -db /scratch/DB/bio/qiime/uchime/gold.fa -nonchimeras otus_chimOUT.fa -strand plus
