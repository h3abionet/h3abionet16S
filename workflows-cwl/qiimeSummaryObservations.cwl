#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: quay.io/h3abionet_org/h3a16s-qiime

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
