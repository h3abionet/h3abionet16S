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

baseCommand: [ uparse_global_search_workaround.sh, otus.mapped.uc ]

outputs:
  ucTabbedFile:
    type: File
    outputBinding:
      glob: otus.mapped.uc

