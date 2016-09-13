#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  fastaFile:
    type: File
    inputBinding:
      position: 1
  otuFastaFile:
    type: File
    inputBinding:
      position: 2
  otuPercentageIdentity:
    type: float
    inputBinding:
      position: 3
  usearchGlobalStrand:
    type: string
    inputBinding:
      position: 4

baseCommand: [ uparse_global_search_workaround.sh ]

outputs:
  ucTabbed:
    type: File
    outputBinding:
      glob: otus.uc

#cwltool uparseGlobalSearchWorkAround.cwl
#--fastaFile /home/shakun/CloudHackathon/h3abionet16S/test/sample_otus/rep_set/61_otus.fasta
#--otuFastaFile /home/shakun/CloudHackathon/h3abionet16S/test/sample_otus/rep_set/67_otus.fasta
#--otuPercentageIdentity 0.97 --usearchGlobalStrand plus

#uparse_global_search_workaround.sh /home/shakun/CloudHackathon/h3abionet16S/test/sample_otus/rep_set/61_otus.fasta
#/home/shakun/CloudHackathon/h3abionet16S/test/sample_otus/rep_set/67_otus.fasta 0.97 plus
