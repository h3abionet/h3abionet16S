#!/usr/bin/env python

# This piece of code was developed by Bryan Brown and he gave us permission to include it in the package.

# USAGE: strip_primers.py Mapping_file input_fasta output_fasta log_filename

from sys import argv
from string import upper
from re import compile

from cogent.parse.fasta import MinimalFastaParser
from skbio.sequence import DNA

from qiime.check_id_map import process_id_map

def get_primers(header,
                mapping_data):
    """ Returns lists of forward/reverse primer regular expression generators

    header:  list of strings of header data.
    mapping_data:  list of lists of mapping data

    Will raise error if either the LinkerPrimerSequence or ReversePrimer fields
        are not present
    """

    if "LinkerPrimerSequence" in header:
        primer_ix = header.index("LinkerPrimerSequence")
    else:
        raise IndexError(
            ("Mapping file is missing LinkerPrimerSequence field."))
    if "ReversePrimer" in header:
        rev_primer_ix = header.index("ReversePrimer")
    else:
        raise IndexError(("Mapping file is missing ReversePrimer field."))

    iupac = {'A': 'A', 'T': 'T', 'G': 'G', 'C': 'C', 'R': '[AG]', 'Y': '[CT]',
             'S': '[GC]', 'W': '[AT]', 'K': '[GT]', 'M': '[AC]', 'B': '[CGT]',
             'D': '[AGT]', 'H': '[ACT]', 'V': '[ACG]', 'N': '[ACGT]'}

    raw_forward_primers = set([])

    raw_reverse_primers = set([])


    for line in mapping_data:
        # Split on commas to handle pool of primers
        raw_forward_primers.update([upper(primer).strip() for
                                    primer in line[primer_ix].split(',')])
        raw_reverse_primers.update([upper(str(DNA(primer).reverse_complement())) for
                                    primer in line[rev_primer_ix].split(',')])


    if not raw_forward_primers:
        raise ValueError(("No forward primers detected in mapping file."))
    if not raw_reverse_primers:
        raise ValueError(("No reverse primers detected in mapping file."))


    forward_primers = []
    reverse_primers = []
    for curr_primer in raw_forward_primers:
        forward_primers.append(compile(''.join([iupac[symbol] for
                                                symbol in curr_primer])))
    for curr_primer in raw_reverse_primers:
        reverse_primers.append(compile(''.join([iupac[symbol] for
                                                symbol in curr_primer])))

    return forward_primers, reverse_primers




map_fp = open(argv[1], "U")

header, mapping_data, run_description, errors, warnings = process_id_map(map_fp)
forward_primers, reverse_primers = get_primers(header, mapping_data)

seqs = open(argv[2], "U")

out_seqs = open(argv[3], "w")
log_out = open(argv[4], "w")

f_count = 0
r_count = 0
no_seq_left = 0

for label,seq in MinimalFastaParser(seqs):
    start_slice = 0
    end_slice = -1
    for curr_primer in forward_primers:
        if curr_primer.search(seq):
            start_slice = int(curr_primer.search(seq).span()[1])
            f_count += 1
    for curr_primer in reverse_primers:
        if curr_primer.search(seq):
            end_slice = int(curr_primer.search(seq).span()[0])
            r_count += 1
    curr_seq = seq[start_slice:end_slice]
    if len(curr_seq) < 1:
        no_seq_left += 1
        continue
    out_seqs.write(">%s\n%s\n" % (label, curr_seq))

log_out.write("Forward primer hits: %d\n" % f_count)
log_out.write("Reverse primer hits: %d\n" % r_count)
log_out.write("No seq left after truncation: %d" % no_seq_left)
