#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusRepsetFasta:
    type: File
    inputBinding:
      prefix: "-i"
  msaAlignMethod:
    type: string
    inputBinding:
      prefix: "-m"
    default: pynast
  otusAlignFasta:
    type: File
    inputBinding:
      prefix: "-t"
baseCommand: [ align_seqs.py, "-o", rep_set_align ]

outputs:
  repSetAlign:
    type: Directory
    outputBinding:
      glob: .



#align_seqs.py -m muscle -i ../../test/sample_otus/rep_set/61_otus.fasta -o rep_set_align
# -t ../../test/sample_otus/rep_set_aligned/61_otus.fasta
