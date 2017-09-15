#!/usr/bin/env nextflow

params.data = "/data/dog_stool_samples"
params.out = "/home/phele/test"
//params.refs =

data_path = params.data
out_path = file(params.out)
//refs = params.ref

out_path.mkdir()

read_pair = Channel.fromFilePairs("${data_path}/*R[1,2].fastq", type: 'file')

process uparseRenameFastq {
    cache = true
    tag { sample }
    stageInMode 'symlink'
    stageOutMode 'rsync'
    container "quay.io/h3abionet_org/h3a16s-in-house"
    publishDir '${out_path}/${sample}', mode: 'copy', overwrite: false

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
    cache = true
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
        -fastq_maxdiffs 3
    """
}


process uparseFilter {
    cache = true
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
        -fastq_maxee 0.1 \
        -fastaout ${sample}_filtered.fasta
    """
}

//filtered_fasta.subscribe { println it }

filtered_fasta
.collectFile () { item -> [ 'fastas.txt', "${item}" + ' ' ] }
.set { fasta_files }


process  uparseDerepWorkAround {
    cache = true
    tag { sample }
    container "quay.io/h3abionet_org/h3a16s-in-house"
    stageInMode 'symlink'
    stageOutMode 'rsync'
    publishDir "$out_path", mode: 'copy', overwrite: false

    input:
	file(fasta) from fasta_files
	
    output:
        file('*') into derep_fasta

    """
    uparse_derep_workaround.sh `more ${fasta}`
    """
}

derep_fasta.subscribe { println it }
