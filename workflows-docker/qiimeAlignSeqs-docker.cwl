#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: longyee/qiime

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



#align_seqs.py -m muscle -i ../../test/sample_otus/rep_set/61_otus.fasta -o rep_set_align
# -t ../../test/sample_otus/rep_set_aligned/61_otus.fasta
