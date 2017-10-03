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
    stageInMode 'symlink'
    stageOutMode 'rsync'
    publishDir "${out_path}/${sample}", mode: 'copy', overwrite: false

    input:
        set sample, file(read) from renamed_read_pair

    output:
        set sample, file("*_merged.fastq") into merged_read_pair

    """
    echo $out_path/${sample}
    usearch -fastq_mergepairs ${sample}_forward_renamed.fastq \
        -reverse ${sample}_reverse_renamed.fastq \
        -fastqout ${sample}_merged.fastq \
        -fastq_maxdiffs ${params.fastqMaxdiffs}
    """
}

process uparseFilter {
    tag { sample }
    stageInMode 'symlink'
    stageOutMode 'rsync'
    publishDir "${out_path}/${sample}", mode: 'copy', overwrite: false

    input:
	set sample, file(read) from merged_read_pair

    output:
	file("${sample}_filtered.fasta") into filtered_fasta

    """
    usearch -fastq_filter ${read} \
        -fastq_maxee ${params.fastqMaxEe} \
        -fastaout ${sample}_filtered.fasta
    """
}

filtered_fasta
.collectFile () { item -> [ 'filtered_fasta.list', "${item}" + ' ' ] }
.set { filtered_fasta_list }


process  uparseDerepWorkAround {
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
	   file(fasta_list) from filtered_fasta_list

    output:
        file('*') into derep_fasta

    """
    uparse_derep_workaround.sh `cat ${fasta_list}`
    """
}

derep_fasta.subscribe { println it }

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
