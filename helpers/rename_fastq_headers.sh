#!/bin/bash

# $1 = sample_id
# $2 = fw_read
# $3 = rv_read
# $4 = fw_read_renamed
# $5 = rv_read_renamed

echo $1
echo $2
echo $3
echo $4
echo $5

# fastx_toolkit needs to be setup in PATH

# Sort out forward read
fastx_renamer -Q33 -n COUNT -i $2 -o $2_tmp
sed \"s/^\(@\|+\)\([0-9]*\)$/\1$1\2;barcodelabel=$1\/1/\" $1_tmp > $1_renamed

# Sort out reverse read
fastx_renamer -Q33 -n COUNT -i $2 -o $2_tmp
sed \"s/^\(@\|+\)\([0-9]*\)$/\1$2\2;barcodelabel=$1\/1/\" $2_tmp > $2_renamed

rm -f $fastq_r1_tmp $fastq_r2_tmp
mv $1_renamed $4
mv $2_renamed $5
