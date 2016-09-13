#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  inputFasta:
    type: File
    inputBinding:
      position: 1
  minLength:
    type: int
    inputBinding:
      position: 2
  maxLength:
    type: int
    inputBinding:
      position: 3
  targetLength:
    type: int
    inputBinding:
      position: 4

baseCommand: [ truncate_seq_lens.py ]

arguments:
  - valueFrom: "truncated.fasta"
    position: 5

outputs:
  outputFasta:
    type: File
    outputBinding:
      glob: truncated.fasta

#truncate_seq_lens.py sample.fasta 250 260 200 truncated.fasta
