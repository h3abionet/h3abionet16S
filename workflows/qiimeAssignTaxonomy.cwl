#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  otusInputFasta:
    type: File
    inputBinding:
      prefix: "-i"
  otusRepsetFasta:
    type: File
    inputBinding:
      prefix: "-r"
  otusTaxFasta:
    type: File
    inputBinding:
      prefix: "-t"
  method:
    type: string
    inputBinding:
      prefix: "-m"
  confVal:
    type: float
    inputBinding:
      prefix: "-c"

baseCommand: [ assign_taxonomy.py,  "-o", tax ]

outputs:
  taxOut:
    type: Directory
    outputBinding:
      glob: .


#assign_taxonomy.py -i ../../test/other_seqs.fna -o tax -r ../../helpers/rep_set/97_otus.fasta
#-t ../../helpers/97_otu_taxonomy.txt -m uclust -c 0.5
