#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
 - class: ScatterFeatureRequirement
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement
 - $import: readPair.yml

inputs:
  fastqSeqs:
    type:
      type: array
      items: "readPair.yml#FilePair"
  fastqMaxdiffs: int
  fastqMaxEe: float

outputs:
  #reports:
  #  type: Directory[]
  #  outputSource: runFastqc/report
  mergedFastQs:
     type: File[]
     outputSource: merge/mergedFastQ

steps:
  arrayOfFilePairsToFileArray:
    run:
      class: ExpressionTool
      inputs:
        arrayOfFilePairs:
          type:
            type: array
            items: "readPair.yml#FilePair"
      outputs:
        pairByPairs: File[]
      expression: >
        ${
        var val;
        var ret = [];
        for (val of inputs.arrayOfFilePairs) {
          ret.push(val.forward);
          ret.push(val.reverse);
        }
        return { 'pairByPairs': ret } ; }
    in:
      arrayOfFilePairs: fastqSeqs
    out: [ pairByPairs ]

  runFastqc:
    run: fastqc-docker.cwl
    in:
      fastqFile: arrayOfFilePairsToFileArray/pairByPairs
    scatter: fastqFile
    out: [ report ]

  uparseRename:
    run: uparseRenameWithMetadata-docker.cwl
    in:
      onePair: fastqSeqs
    scatter: onePair
    out: [ renamedPair ]

  merge:
    run: uparseRenameFastQ-docker.cwl
    in:
      sampleName:
        source: uparseRename/renamedPair
        valueFrom: $(self.sample_id)
      fastqFileF:
        source: uparseRename/renamedPair
        valueFrom: $(self.forward)
      fastqFileR:
        source: uparseRename/renamedPair
        valueFrom: $(self.reverse)
      fastqMaxdiffs: fastqMaxdiffs
    scatter: [ sampleName, fastqFileF, fastqFileR ]
    scatterMethod: dotproduct
    out: [ mergedFastQ ]

  filter:
    run: uparseFilter-docker.cwl
    in:
      fastqFile: merge/mergedFastQ
      fastqMaxEe: fastqMaxEe
    scatter: [ fastqFile ]
    scatterMethod: dotproduct
    out: [ filteredFasta ]
