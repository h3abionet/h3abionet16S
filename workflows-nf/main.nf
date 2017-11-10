#!/usr/bin/env nextflow

data_path = params.data
out_path = file(params.out)

out_path.mkdir()

read_pair = Channel.fromFilePairs("${data_path}/*R[1,2].fastq", type: 'file')

process uparseRenameFastq {
    tag { "${params.project_name}.uRF.${sample}" }
    publishDir "${out_path}/${sample}", mode: 'copy', overwrite: false

    input:
	   set sample, file(read) from read_pair

    output:
	   set sample, file("*renamed.fastq") into renamed_read_pair

    """
    rename_fastq_headers.sh ${sample} \
        ${read.get(0)} ${read.get(1)} \
	    ${sample}_forward_renamed.fastq \
	    ${sample}_reverse_renamed.fastq
    """
}

process uparseFastqMerge {
    tag { "${params.project_name}.uFM.${sample}" }
    publishDir "${out_path}/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(read) from renamed_read_pair

    output:
        set sample, file("*_merged.fastq") into merged_read_pair

    """
    echo $out_path/${sample}
    usearch -threads 1 -fastq_mergepairs ${sample}_forward_renamed.fastq \
        -reverse ${sample}_reverse_renamed.fastq \
        -fastqout ${sample}_merged.fastq \
        -fastq_maxdiffs ${params.fastqMaxdiffs}
    """
}

process uparseFilter {
    tag { "${params.project_name}.uF.${sample}" }
    publishDir "${out_path}/${sample}", mode: 'copy', overwrite: false

    input:
	set sample, file(read) from merged_read_pair

    output:
	file("${sample}_filtered.fasta") into filtered_fasta

    """
    usearch -threads 1 -fastq_filter ${read} \
        -fastq_maxee ${params.fastqMaxEe} \
        -fastaout ${sample}_filtered.fasta
    """
}

filtered_fasta.into { filtered_fasta_p1; filtered_fasta_p2 }

filtered_fasta_p1
.collectFile () { item -> [ 'filtered_fasta_p1.list', "${item}" + ' ' ] }
.set { filtered_fasta_list_p1 }

filtered_fasta_p2
.collectFile () { item -> [ 'filtered_fasta_p2.list', "${item}" + ' ' ] }
.set { filtered_fasta_list_p2 }

process  uparseDerepWorkAround {
    tag { "${params.project_name}.uDWA" }
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
	   file(fasta_list) from filtered_fasta_list_p1

    output:
        file('*') into derep_fasta

    """
    uparse_derep_workaround.sh `cat ${fasta_list}`
    """
}

process uparseSort {
    tag { "${params.project_name}.uS" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.uOP" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.uCC" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.RO" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.cF" }
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
	   file(fasta_list) from filtered_fasta_list_p2

    output:
        file('*') into concat_fasta

    """
    concat_fasta.sh `cat ${fasta_list}`
    """
}

process uparseGlobalSearchWorkAround {
    tag { "${params.project_name}.uGSWA" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.uOTT" }
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
        file(in_file) from uc_tabbed_file

    output:
        file('otu-table.txt') into otu_table_file

    """
    python /usr/local/bin/uc2otutab.py ${in_file} > otu-table.txt
    """
}

process qiimeOtuTextToBiom {
    tag { "${params.project_name}.qOTTB" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.qAT" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.qAM" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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

process qiimeAlignSeqs {
    tag { "${params.project_name}.qAS" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.qFA" }
    publishDir "$out_path", mode: 'copy', overwrite: false

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
    tag { "${params.project_name}.uMP" }
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
        file(in_fasta) from otus_renamed_aligned_pfiltered_fasta

    output:
        file('otus.tre') into otus_tree_file

    """
    make_phylogeny.py -i ${in_fasta} \
        -o otus.tre
    """
}

otus_tree_file.subscribe { println it }
otu_tax_biom_file.subscribe { println it }

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
