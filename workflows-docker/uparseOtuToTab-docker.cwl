#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusMappedOUTFasta:
    type: File

baseCommand: [ uc2otutab.py ]

stdout: otus_table.tab.txt

outputs:
  otusTableTabTxt:
    type: stdout





#uc2otutab.py $outDir/otus_mappedOUT.uc > $outDir/otus_table.tab.txt
