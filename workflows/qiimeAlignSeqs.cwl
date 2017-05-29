#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: quay.io/h3abionet_org/h3a16s-qiime

inputs:
  otuFasta:
    type: File
    inputBinding:
      prefix: "-i"
  alignmentMethod:
    type: string
    inputBinding:
      prefix: "-m"
    default: pynast
  otuRepsetAlignmentTemplateFasta:
    type: File
    inputBinding:
      prefix: "-t"
baseCommand: [ align_seqs.py, "-o", otus.align ]

outputs:
  otuAlignedFasta:
    type: File
    outputBinding:
      glob: otus.align/otus_renamed_aligned.fasta
