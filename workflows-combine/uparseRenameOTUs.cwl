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
      position: 1

#baseCommand: [ fasta_number.py ]
baseCommand: [ python, /usr/local/bin/fasta_number.py ]

arguments:
  - valueFrom: "OTU_"
    position: 2

stdout: otus_renamed.fasta

outputs:
  renamedFasta:
    type: stdout

#fasta_number.py $outDir/otus_chimOUT.fa OTU_ > $outDir/otus_repsetOUT.fa
