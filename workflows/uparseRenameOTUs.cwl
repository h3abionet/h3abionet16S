#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  fasta:
    type: File
    inputBinding:
      position: 1
  prefix:
    type: string
    inputBinding:
      position: 2

baseCommand: [ fasta_number.py ]

stdout: renamed.fasta

outputs:
  renamedFasta:
    type: stdout


#fasta_number.py $outDir/otus_chimOUT.fa OTU_ > $outDir/otus_repsetOUT.fa
