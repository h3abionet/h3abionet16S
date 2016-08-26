#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusTaxBiom:
    type: File
    inputBinding:
      prefix: "-i"
baseCommand: [ biom, summarize-table, "-o", otus_table.tax.biom.summary ]

outputs:
  otusTabTaxSummary:
    type: File
    outputBinding:
      glob: otus_table.tax.biom.summary


# biom summarize-table -i otus_table.tax.biom -o otus_table.tax.biom.summary
