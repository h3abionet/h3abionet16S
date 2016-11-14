#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otuBiom:
    type: File
    inputBinding:
      position: 1
  mappingFile:
    type: File
    inputBinding:
      position: 2
  treeFile:
    type: File
    inputBinding:
      position: 3

baseCommand: [ generate_R_reports.R ]

outputs:
  reports:
    type: File[]
    outputBinding:
     glob: "rReports/*.jpg"
     #glob: "$(inputs.outDir)/*.jpg"

# Commandline: Rscript PhyloseqReport.R otus.tax.biom dog_stool_samples_metadata.tsv otus.tre output
# cwl command: cwltool --debug R_Reports.cwl --otuFile otus.tax.biom --mapFile dog_stool_samples_metadata.tsv --tre otus.tre --outDir output
