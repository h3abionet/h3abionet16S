#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusTableTabTxt:
    type: File
    inputBinding:
      prefix: "-i"
  otuTable:
    type: string
    inputBinding:
      prefix: "--table-type="
      separate: false
    default: "OTU table"

baseCommand: [ biom, convert, "-o", otus_table.biom, "--to-json" ]

outputs:
  otusTableBiom:
    type: File
    outputBinding:
      glob: otus_table.biom


#biom convert -i ../../test/other_otus.txt -o otus_table.biom --table-type="OTU table" --to-json
