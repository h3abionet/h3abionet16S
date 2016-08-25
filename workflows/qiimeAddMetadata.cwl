#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusTableBiom:
    type: File
    inputBinding:
      prefix: "-i"
  taxAssignedTxt:
    type: File
    inputBinding:
      prefix: "--observation-metadata-fp"


baseCommand: [ biom ,add-metadata,  "-o", otus_table.tax.biom, "--observation-header", "OTUID,taxonomy,confidence",
              "--sc-separated", "taxonomy", "--float-fields", "confidence", "--output-as-json" ]

outputs:
  otusTableTaxBiom:
    type: File
    outputBinding:
      glob: otus_table.tax.biom

#biom add-metadata -i otus_table.biom -o otus_table.tax.biom --observation-metadata-fp tax/other_seqs_tax_assignments.txt
#--observation-header OTUID,taxonomy,confidence --sc-separated taxonomy --float-fields confidence --output-as-json
