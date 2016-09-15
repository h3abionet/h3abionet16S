#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otuBiom:
    type: File
    inputBinding:
      prefix: "-i"
      
baseCommand: [ biom, summarize-table, "--qualitative","-o", otus.summary.qualitative ]

outputs:
  otuSummary:
    type: File
    outputBinding:
      glob: otus.summary.qualitative

# biom summarize-table -i otus_table.tax.biom -o otus_table.tax.biom.summary
