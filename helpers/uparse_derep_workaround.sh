#!/bin/bash

# $1 = dir with individual fasta files
# $2 = file file individual files concatenated
# $3 = dereplicated fasta file
# $4 = error file 

echo $1
echo $2
echo $3
echo $4

cat $1/*.fasta > $2

cat $1 | grep -v "^>" | grep -v [^ACGTacgt] | sort -d | uniq -c | while read abundance sequence ; do hash=$(printf "${sequence}" | sha1sum); hash=${hash:0:40};printf ">%s;size=%d;\n%s\n" "${hash}" "${abundance}" "${sequence}"; done > $3 2> $4



