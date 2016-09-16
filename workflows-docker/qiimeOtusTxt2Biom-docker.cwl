#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/qiime

inputs:
  otuTable:
    type: File
    inputBinding:
      prefix: "-i"
  otuTableType:
    type: string
    inputBinding:
      prefix: "--table-type="
      separate: false
    default: "OTU table"

baseCommand: [ biom, convert, "-o", otus.biom, "--to-json" ]

outputs:
  otuBiom:
    type: File
    outputBinding:
      glob: otus.biom

#biom convert -i ../../test/other_otus.txt -o otus_table.biom --table-type="OTU table" --to-json
