#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/qiime

inputs:
  otuBiom:
    type: File
    inputBinding:
      prefix: "-i"
      
baseCommand: [ biom, summarize-table, "--observations","-o", otus.summary.observations ]

outputs:
  otuSummary:
    type: File
    outputBinding:
      glob: otus.summary.observations

# biom summarize-table -i otus_table.tax.biom -o otus_table.tax.biom.summary
