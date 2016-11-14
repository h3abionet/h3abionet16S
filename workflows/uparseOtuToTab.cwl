#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  ucTabbed:
    type: File
    inputBinding:
      position: 1

#baseCommand: [ uc2otutab.py ]
baseCommand: [ python, /usr/local/bin/uc2otutab.py ]

stdout: otus.table

outputs:
  otuTable:
    type: stdout
