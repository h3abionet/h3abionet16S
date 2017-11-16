#!/usr/bin/env python

# This piece of code was developed by Bryan Brown and he gave us permission to include it in the package.

""" Usage
python truncate_seq_lens.py X Y Z A
where
X is input fasta file
Y is the minimum sequence length (discards reads shorter than this)
Z is the maximum sequence length (discards reads longer than this)
A is target truncation length
B is output fasta file
"""

from sys import argv

from cogent.parse.fasta import MinimalFastaParser

f = open(argv[1], "U")
min_trunc_len = int(argv[2])
max_trunc_len = int(argv[3])
trunc_len = int(argv[4])
out_f = open(argv[5], "w")


for label,seq in MinimalFastaParser(f):
    if len(seq) < min_trunc_len or len(seq) > max_trunc_len:
        continue
    out_f.write(">%s\n%s\n" % (label, seq[0:trunc_len]))
