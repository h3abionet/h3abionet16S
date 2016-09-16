#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  ucTabbed:
    type: File
    inputBinding:
      position: 1

baseCommand: [ uc2otutab.py ]

stdout: otus.table

outputs:
  otuTable:
    type: stdout

#python /home/shakun/python_scripts/uc2otutab.py otus.mapped.uc > otu-table.txt
#uc2otutab.py otus.mapped.uc > otu-table.txt
