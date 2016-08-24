#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

inputs:
  filteredSortedFasta:
    type: File
    inputBinding:
      prefix: "-cluster_otus"
  otuRadiusPct:
    type: float
    inputBinding:
      prefix: "-otu_radius_pct"
baseCommand: [ usearch8,  "-otus", otus_raw.fasta ]

outputs:
  filteredSortedFasta:
    type: File
    outputBinding:
      glob: otus_raw.fasta




#usearch7 -cluster_otus $outDir/filtered_all.uniques.sorted.fa -otu_radius_pct 3.0 -otus $outDir/otus_raw.fa
