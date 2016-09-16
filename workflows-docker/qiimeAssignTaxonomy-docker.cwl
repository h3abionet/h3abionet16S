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
  otuRepsetFasta:
    type: File
    inputBinding:
      prefix: "-r"
  otuRepsetTax:
    type: File
    inputBinding:
      prefix: "-t"
  assignTaxonomyMethod:
    type: string
    inputBinding:
      prefix: "-m"
  assignTaxonomyConfVal:
    type: float
    inputBinding:
      prefix: "-c"

baseCommand: [ assign_taxonomy.py,  "-o", tax ]

outputs:
  otuTaxonomy:
    type: File
    outputBinding:
      glob: "tax/*.txt"

#assign_taxonomy.py -i ../../test/other_seqs.fna -o tax -r ../../helpers/rep_set/97_otus.fasta
#-t ../../helpers/97_otu_taxonomy.txt -m uclust -c 0.5
