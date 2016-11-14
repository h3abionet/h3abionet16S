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
  minSize: int
  otuRadiusPct: float
  chimeraFastaDb: File
  strandInfo: string
  chimeraCheckMode: string 
  otuPercentageIdentity: float
  usearchGlobalStrand: string
  otuTableType: string
  otuRepsetFasta: File
  otuRepsetTax: File
  assignTaxonomyMethod: string
  assignTaxonomyConfVal: float
  otuRepsetAlignmentTemplateFasta: File
  alignmentMethod: string
  mappingFile: File

outputs:
  reports:
    type: Directory[]
    outputSource: runFastqc/report

  renamedFastqFile:
    type: "readPair.yml#FilePair[]"
    outputSource: uparseRename/renamedPair

  mergedFastQs:
     type: File[]
     outputSource: merge/mergedFastQ

  filteredFastaFiles:
    type: File[]
    outputSource: filter/filteredFasta

  derepFastaFile:
    type: File
    outputSource: derep/derepFasta

  sortedFastaFile:
    type: File
    outputSource: sort/sortedFasta

  otuFastaFile:
    type: File
    outputSource: otuPick/otuFasta

  noChimeraFastaFile:
    type: File
    outputSource: chimeraCheck/chimeraCleanFasta

  renamedOTUFastaFile:
    type: File
    outputSource: renameOTU/renamedFasta

  concatFastaFile:
    type: File
    outputSource: concatFasta/concatFasta

  ucTabbedFile:
    type: File
    outputSource: underep/ucTabbed

  otuTableFile:
    type: File
    outputSource: uparseUCtoTab/otuTable

  otuBiomFile:
    type: File
    outputSource: otuTableToBiom/otuBiom

  otuTaxonomyFile:
    type: File
    outputSource: assignTaxonomy/otuTaxonomy

  otuBiomTaxonomyFile:
    type: File
    outputSource: addTaxonomyToBiom/otuBiom

  otuAlignedFastaFile:
    type: File
    outputSource: align/otuAlignedFasta

  otuFilteredAlignmentFastaFile:
    type: File
    outputSource: filterAlignment/otuFilteredAlignmentFasta

  otuTreeFile:
    type: File
    outputSource: makePhylogeny/otuTree

  otuSummaryeObservationsFile:
    type: File
    outputSource: createSummaryObservations/otuSummary

  otuSummaryQualitativeFile:
    type: File
    outputSource: createSummaryQualitative/otuSummary

  rReports:
    type: File[]
    outputSource: generateRReports/reports 

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
    run: fastqc.cwl
    in:
      fastqFile: arrayOfFilePairsToFileArray/pairByPairs
    scatter: fastqFile
    out: [ report ]

  uparseRename:
    run: uparseRenameWithMetadata.cwl
    in:
      onePair: fastqSeqs
    scatter: onePair
    out: [ renamedPair ]

  merge:
    run: uparseFastqMerge.cwl
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
    run: uparseFilter.cwl
    in:
      fastqFile: merge/mergedFastQ
      fastqMaxEe: fastqMaxEe
    scatter: [ fastqFile ]
    scatterMethod: dotproduct
    out: [ filteredFasta ]

  # add strip primer step here

  # add truncate length step here

  derep:
    run: uparseDerepWorkAround.cwl
    in:
      fastaFiles: filter/filteredFasta
    out:  [ derepFasta ]

  sort:
    run: uparseSort.cwl
    in:
      fastaFile: derep/derepFasta
      minSize: minSize
    out: [ sortedFasta ]

  otuPick:
    run: uparseOTUPick.cwl
    in:
      fastaFile: sort/sortedFasta
      otuRadiusPct: otuRadiusPct
    out: [ otuFasta ]

  chimeraCheck:
    run: uparseChimeraCheck.cwl
    in:
      fastaFile: otuPick/otuFasta
      chimeraFastaDb: chimeraFastaDb
      strandInfo: strandInfo
      chimeraCheckMode: chimeraCheckMode
    out: [ chimeraCleanFasta ]

  renameOTU:
    run: uparseRenameOTUs.cwl
    in:
      fastaFile: chimeraCheck/chimeraCleanFasta
    out: [ renamedFasta ]

  concatFasta:
    run: concatFasta.cwl
    in:
     fastaFiles: filter/filteredFasta
    out: [ concatFasta ]

  underep:
    run: uparseGlobalSearchWorkAround.cwl
    in:
      fastaFile: concatFasta/concatFasta
      otuFastaFile: renameOTU/renamedFasta
      otuPercentageIdentity: otuPercentageIdentity
      usearchGlobalStrand: usearchGlobalStrand
    out: [ ucTabbed ]

  uparseUCtoTab:
    run: uparseOtuToTab.cwl
    in:
      ucTabbed: underep/ucTabbed
    out: [ otuTable ]

  otuTableToBiom:
    run: qiimeOtusTxt2Biom.cwl
    in:
      otuTable: uparseUCtoTab/otuTable
    out: [ otuBiom ]

  assignTaxonomy:
    run: qiimeAssignTaxonomy.cwl
    in:
      otuFasta: renameOTU/renamedFasta
      otuRepsetFasta: otuRepsetFasta
      otuRepsetTax: otuRepsetTax
      assignTaxonomyMethod: assignTaxonomyMethod
      assignTaxonomyConfVal: assignTaxonomyConfVal
    out: [ otuTaxonomy ]

  addTaxonomyToBiom:
    run: qiimeAddMetadata.cwl
    in:
      otuBiom: otuTableToBiom/otuBiom
      otuTaxonomy: assignTaxonomy/otuTaxonomy
    out: [ otuBiom ]

  align:
    run: qiimeAlignSeqs.cwl
    in:
      otuFasta: renameOTU/renamedFasta
      alignmentMethod: alignmentMethod
      otuRepsetAlignmentTemplateFasta: otuRepsetAlignmentTemplateFasta
    out: [ otuAlignedFasta ]

  filterAlignment:
    run: qiimeFilterAlign.cwl
    in:
      otuFasta: align/otuAlignedFasta
    out: [ otuFilteredAlignmentFasta ]

  makePhylogeny:
    run: qiimeMakePhylogeny.cwl
    in:
      otuFasta: filterAlignment/otuFilteredAlignmentFasta
    out: [ otuTree ]

  createSummaryObservations:
    run: qiimeSummaryObservations.cwl
    in:
      otuBiom: addTaxonomyToBiom/otuBiom
    out: [ otuSummary ]

  createSummaryQualitative:
    run: qiimeSummaryQualitative.cwl
    in:
      otuBiom: addTaxonomyToBiom/otuBiom
    out: [ otuSummary ]

  generateRReports:
    run: generateRReports.cwl
    in:
     otuBiom: addTaxonomyToBiom/otuBiom
     mappingFile: mappingFile
     treeFile: makePhylogeny/otuTree
    out: [ reports ]
