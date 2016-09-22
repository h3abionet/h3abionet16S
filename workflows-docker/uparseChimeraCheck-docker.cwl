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
      prefix: "-uchime_ref"
  chimeraFastaDb:
    type: File
    inputBinding:
      prefix: "-db"
  strandInfo:
    type: string
    inputBinding:
      prefix: "-strand"

#baseCommand: [ usearch8,  "-nonchimeras", no_chimera.fasta ]
#baseCommand: [ "-nonchimeras", no_chimera.fasta ]
baseCommand: [ usearch8,  "-nonchimeras", no_chimera.fasta ]

outputs:
  chimeraCleanFasta:
    type: File
    outputBinding:
      glob: no_chimera.fasta

#usearch8 -uchime_ref $outDir/otus_raw.fa -db /scratch/DB/bio/qiime/uchime/gold.fa -nonchimeras otus_chimOUT.fa -strand plus
