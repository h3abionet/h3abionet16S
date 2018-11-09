#!/usr/bin/env nextflow

raw_reads = params.rawReads
out_dir = file(params.outDir)

out_dir.mkdir()

read_pair = Channel.fromFilePairs("${raw_reads}/*R[1,2].fastq", type: 'file')

read_pair.into { read_pair_p1; read_pair_p2 }

process runFastQC{
    tag { "${params.projectName}.rFQC.${sample}" }
    label 'fastqc'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/qc/raw/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(in_fastq) from read_pair_p1

    output:
        file("${sample}_fastqc/*.zip") into fastqc_files

    """
    mkdir ${sample}_fastqc
    fastqc --outdir ${sample}_fastqc \
    ${in_fastq.get(0)} \
    ${in_fastq.get(1)}
    """
}

process runMultiQC{
    tag { "${params.projectName}.rMQC" }
    label 'fastqc'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/qc/raw", mode: 'copy', overwrite: false

    input:
        file('*') from fastqc_files.collect()

    output:
        file('multiqc_report.html')

    """
    multiqc .
    """
}

process uparseRenameFastq {
    tag { "${params.projectName}.uRF.${sample}" }
    label 'in_house'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
	   set sample, file(in_fastq) from read_pair_p2

    output:
	   set sample, file("*renamed.fastq") into renamed_read_pair

    """
    rename_fastq_headers.sh ${sample} \
        ${in_fastq.get(0)} ${in_fastq.get(1)} \
	    ${sample}_forward_renamed.fastq \
	    ${sample}_reverse_renamed.fastq
    """
}

process uparseFastqMerge {
    tag { "${params.projectName}.uFM.${sample}" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(in_fastq) from renamed_read_pair

    output:
        set sample, file("*_merged.fastq") into merged_read_pair

    """
    echo $out_dir/${sample}
    usearch -threads 1 -fastq_mergepairs ${sample}_forward_renamed.fastq \
        -reverse ${sample}_reverse_renamed.fastq \
        -fastqout ${sample}_merged.fastq \
        -fastq_maxdiffs ${params.fastqMaxdiffs}
    """
}

process uparseFilter {
    tag { "${params.projectName}.uF.${sample}" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
	set sample, file(in_fastq) from merged_read_pair

    output:
	set sample, file("${sample}_filtered.fastq") into filtered_fastq

    """
    usearch -threads 1 -fastq_filter ${in_fastq} \
        -fastq_maxee ${params.fastqMaxEe} \
        -fastqout ${sample}_filtered.fastq
    """
}

filtered_fastq.into { filtered_fastq_p1; filtered_fastq_p2 }

process uparseFastqToFasta {
    tag { "${params.projectName}.uF.${sample}" }
    label 'in_house'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
    set sample, file(in_fastq) from filtered_fastq_p1

    output:
    set sample, file("${sample}_filtered.fasta") into filtered_fasta

    """
    seqtk seq -A ${in_fastq} \
        > ${sample}_filtered.fasta
    """
}

process runFastQCOnFiltered{
    tag { "${params.projectName}.rFQCOF.${sample}" }
    label 'fastqc'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/qc/filtered/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(in_fastq) from filtered_fastq_p2

    output:
        file("${sample}_fastqc/*.zip") into fastqc_filtered_files

    """
    mkdir ${sample}_fastqc
    fastqc --outdir ${sample}_fastqc \
    ${in_fastq} \
    """
}

process runMultiQCOnFiltered{
    tag { "${params.projectName}.rMQCOF" }
    label 'fastqc'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/qc/filtered", mode: 'copy', overwrite: false

    input:
        file('*') from fastqc_filtered_files.collect()

    output:
        file('multiqc_report.html')

    """
    multiqc .
    """
}

process uparseStripPrimers{
    tag { "${params.projectName}.uSP.${sample}" }
    label 'qiime' 
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(in_fasta) from filtered_fasta

    output:
        set sample, file("${sample}_filtered_stripped_primers.fasta") into filtered_stripped_primers_fasta
        file("${sample}_filtered_stripped_primers.log")

    """
    strip_primers.py ${params.qiimeMappingFile} \
        ${in_fasta} \
        ${sample}_filtered_stripped_primers.fasta  \
        ${sample}_filtered_stripped_primers.log
    """
}

process uparseTruncateReads{
    tag { "${params.projectName}.uTR.${sample}" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "${out_dir}/read_processing/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(in_fasta) from filtered_stripped_primers_fasta

    output:
        file("${sample}_filtered_stripped_primers_truncated.fasta") into filtered_stripped_primers_truncated_fasta

    """
    truncate_seq_len.py ${in_fasta} \
        ${params.minLen} \
        ${params.maxLen} \
        ${params.targetLen} \
        ${sample}_filtered_stripped_primers_truncated.fasta
    """
}

filtered_stripped_primers_truncated_fasta.into { filtered_stripped_primers_truncated_fasta_p1; filtered_stripped_primers_truncated_fasta_p2 }

filtered_stripped_primers_truncated_fasta_p1
.collectFile () { item -> [ 'ffiltered_stripped_primers_truncated_fasta_p1.list', "${item}" + ' ' ] }
.set { filtered_stripped_primers_truncated_fasta_list_p1 }

filtered_stripped_primers_truncated_fasta_p2
.collectFile () { item -> [ 'filtered_stripped_primers_truncated_fasta_p2.list', "${item}" + ' ' ] }
.set { filtered_stripped_primers_truncated_fasta_list_p2 }

process  uparseDerepWorkAround {
    tag { "${params.projectName}.uDWA" }
    label 'in_house'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/read_processing", mode: 'copy', overwrite: false

    input:
	   file(fasta_list) from filtered_stripped_primers_truncated_fasta_list_p1

    output:
        file('*') into derep_fasta

    """
    uparse_derep_workaround.sh `cat ${fasta_list}`
    """
}

process uparseSort {
    tag { "${params.projectName}.uS" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/read_processing", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from derep_fasta

    output:
        file('sorted.fasta') into sorted_fasta

    """
    usearch -sortbysize ${in_fasta} \
        -minsize ${params.minSize} \
        -fastaout sorted.fasta
    """
}

process uparseOTUPick {
    tag { "${params.projectName}.uOP" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from sorted_fasta

    output:
        file('otus_raw.fasta') into otus_raw_fasta

    """
    usearch -cluster_otus ${in_fasta} \
        -otu_radius_pct ${params.otuRadiusPct} \
        -otus otus_raw.fasta
    """
}

process uparseChimeraCheck {
    tag { "${params.projectName}.uCC" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from otus_raw_fasta

    output:
        file('no_chimera.fasta') into no_chimera_fasta

    """
    usearch -threads 1 -uchime2_ref ${in_fasta} \
        -db ${params.chimeraFastaDb} \
        -strand ${params.strandInfo} \
        -mode ${params.chimeraCheckMode} \
        -notmatched no_chimera.fasta
    """
}

process uparseRenameOTUs {
    tag { "${params.projectName}.RO" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from no_chimera_fasta

    output:
        file('otus_renamed.fasta') into otus_renamed_fasta

    """
    python /usr/local/bin/fasta_number.py ${in_fasta} \
        "OTU_" > otus_renamed.fasta
    """
}

otus_renamed_fasta.into { otus_renamed_fasta_p1; otus_renamed_fasta_p2; otus_renamed_fasta_p3 }

process  concatFasta {
    tag { "${params.projectName}.cF" }
    label 'in_house'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/read_processing", mode: 'copy', overwrite: false

    input:
	   file(fasta_list) from filtered_stripped_primers_truncated_fasta_list_p2

    output:
        file('*') into concat_fasta

    """
    concat_fasta.sh `cat ${fasta_list}`
    """
}

process uparseGlobalSearchWorkAround {
    tag { "${params.projectName}.uGSWA" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from concat_fasta
        file(otu_fasta) from otus_renamed_fasta_p1

    output:
        file('otus.uc') into uc_tabbed_file

    """
    uparse_global_search_workaround.sh ${in_fasta} \
        ${otu_fasta} \
        ${params.otuPercentageIdentity} \
        ${params.usearchGlobalStrand} \
    """
}

process uparseOtuToTab {
    tag { "${params.projectName}.uOTT" }
    label 'usearch'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_file) from uc_tabbed_file

    output:
        file('otu-table.txt') into otu_table_file

    """
    python /usr/local/bin/uc2otutab.py ${in_file} > otu-table.txt
    """
}

process qiimeOtuTextToBiom {
    tag { "${params.projectName}.qOTTB" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_picking", mode: 'copy', overwrite: false

    input:
        file(in_file) from otu_table_file

    output:
        file('otus_table.biom') into otu_biom_file

    """
    biom convert -i ${in_file} \
    -o otus_table.biom \
    --table-type="OTU table" \
    --to-json
    """
}

otu_biom_file.into { otu_biom_file_p1; otu_biom_file_p2 }

process qiimeAssignTaxonomy {
    tag { "${params.projectName}.qAT" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_processing", mode: 'copy', overwrite: false

    input:
        file(in_file) from otu_biom_file_p1
        file(in_fasta) from otus_renamed_fasta_p3

    output:
        file('tax/otus_renamed_tax_assignments.txt') into otu_tax_file

    """
    assign_taxonomy.py -i ${in_fasta} \
    -o tax \
    -r ${params.otuRepsetFasta} \
    -t ${params.otuRepsetTax} \
    -m ${params.asignTaxonomyMethod} \
    -c ${params.assignTaxonomyConfVal}
    """
}

process qiimeAddMetadata {
    tag { "${params.projectName}.qAM" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_processing", mode: 'copy', overwrite: false

    input:
        file(in_biom_file) from otu_biom_file_p2
        file(in_tax_file) from otu_tax_file

    output:
        file('otus_table.tax.biom') into otu_tax_biom_file

    """
    biom add-metadata -i ${in_biom_file} \
   -o otus_table.tax.biom \
   --observation-metadata-fp ${in_tax_file} \
   --observation-header OTUID,taxonomy,confidence \
   --sc-separated taxonomy \
   --float-fields confidence \
    --output-as-json
    """
}

otu_tax_biom_file.into { otu_tax_biom_file_p1; otu_tax_biom_file_p2; otu_tax_biom_file_p3 }

process qiimeSummarySampleOTUCount  {
    tag { "${params.projectName}.qSSOC" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/summaries", mode: 'copy', overwrite: false

    input:
        file(in_biom_file) from otu_tax_biom_file_p1

    output:
        file('summary.sample_otu_count.txt') into summary_sample_otu_count_file

    """
    biom summarize-table -i ${in_biom_file} \
    --qualitative \
   -o summary.sample_otu_count.txt \
    """
}

process qiimeSummaryOTUReadCount  {
    tag { "${params.projectName}.qSORC" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/summaries", mode: 'copy', overwrite: false

    input:
        file(in_biom_file) from otu_tax_biom_file_p2

    output:
        file('summary.otu_read_count.txt') into summary_otu_read_count_file

    """
    biom summarize-table -i ${in_biom_file} \
    --observations \
   -o summary.otu_read_count.txt \
    """
}

process qiimeSummarySampleReadCount  {
    tag { "${params.projectName}.qSSRC" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/summaries", mode: 'copy', overwrite: false

    input:
        file(in_biom_file) from otu_tax_biom_file_p3

    output:
        file('summary.sample_read_count.txt') into summary_sample_read_count_file

    """
    biom summarize-table -i ${in_biom_file} \
   -o summary.sample_read_count.txt \
    """
}


process qiimeAlignSeqs {
    tag { "${params.projectName}.qAS" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    cpus { 20 }
    publishDir "$out_dir/otu_processing", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from otus_renamed_fasta_p2

    output:
        file('otus.align/otus_renamed_aligned.fasta') into otus_renamed_aligned_fasta

    """
    align_seqs.py -i ${in_fasta} \
        -m ${params.alignmentMethod} \
        -t ${params.otuRepsetAlignmentTemplateFasta} \
        -o otus.align
    """
}

process qiimeFilterAlign {
    tag { "${params.projectName}.qFA" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_processing", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from otus_renamed_aligned_fasta

    output:
        file('filtered_alignment/otus_renamed_aligned_pfiltered.fasta') into otus_renamed_aligned_pfiltered_fasta

    """
    filter_alignment.py -i ${in_fasta} \
        -o filtered_alignment
    """
}

process qiimeMakePhylogeny {
    tag { "${params.projectName}.uMP" }
    label 'qiime'
    memory { 4.GB * task.attempt }
    publishDir "$out_dir/otu_processing", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from otus_renamed_aligned_pfiltered_fasta

    output:
        file('otus.tre') into otus_tree_file

    """
    make_phylogeny.py -i ${in_fasta} \
        -o otus.tre
    """
}

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}
