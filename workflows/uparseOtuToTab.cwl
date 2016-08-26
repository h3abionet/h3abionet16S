#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  pythonCommand:
    type: File
    inputBinding:
      position: 1
  otusMappedOUTFasta:
    type: File
    inputBinding:
      position: 2

baseCommand: [python ]

stdout: otus_table.tab.txt

outputs:
  otusTableTabTxt:
    type: stdout





#python /home/shakun/python_scripts/uc2otutab.py otus.mapped.uc > otu-table.txt
