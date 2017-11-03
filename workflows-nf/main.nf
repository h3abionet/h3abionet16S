#!/usr/bin/env nextflow

data_path = params.data
out_path = file(params.out)

out_path.mkdir()

read_pair = Channel.fromFilePairs("${data_path}/*R[1,2].fastq", type: 'file')

process uparseRenameFastq {
    tag { sample }
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
    tag { sample }
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
    tag { sample }
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

otus_renamed_fasta.into { otus_renamed_fasta_p1; otus_renamed_fasta_p2 }

process  concatFasta {
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


process qiimeAlignSeqs {

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

uc_tabbed_file.subscribe { println it }
otus_tree_file.subscribe { println it }

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
