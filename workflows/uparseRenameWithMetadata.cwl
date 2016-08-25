cwlVersion: v1.0
class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - $import: readPair.yml

inputs:
  onePair: "readPair.yml#FilePair"

outputs:
  renamedPair:
    type: "readPair.yml#FilePair"
    outputSource: packageRenamedFastqs/pairWithMetadata         

steps:
  uparseRenameSimple:
    run: uparseRenameFastQ.cwl
    in:
      sampleName:
        source: onePair
        valueFrom: $(self.sample_id)
      fastqFileF:
        source: onePair
        valueFrom: $(self.forward)
      fastqFileR:
        source: onePair
        valueFrom: $(self.reverse)
    out: [ forwardRename, reverseRename ]
  packageRenamedFastqs:
    run:
      class: ExpressionTool
      inputs:
        forward: File
        reverse: File
        sample_id: string
      outputs:
        pairWithMetadata: "readPair.yml#FilePair"
      expression: >
        ${
        var ret = {} ;
        ret["forward"] = inputs.forward;
        ret["reverse"] = inputs.reverse;
        ret["sample_id"] = inputs.sample_id;
        return { "pairWithMetadata": ret } ; }
    in:
      forward: uparseRenameSimple/forwardRename
      reverse: uparseRenameSimple/reverseRename
      sample_id:
        source: onePair
        valueFrom: $(self.sample_id)
    out: [ pairWithMetadata ]

