#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  fastaFile:
    type: File
    inputBinding:
      position: 1
  otuFastaFile:
    type: File
    inputBinding:
      position: 2
  otuPercentageIdentity:
    type: string 
    inputBinding:
      position: 3
  usearchGlobalStrand:
    type: string
    inputBinding:
      position: 4
  ucTabbedFile:
    type: File
    inputBinding:
      position: 5

baseCommand: [ uparse_global_search_workaround.sh, derep.fasta]

outputs:
  ucTabbedFile:
    type: File
    outputBinding:
      glob: otus.mapped.uc

