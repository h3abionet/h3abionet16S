#!/bin/bash

# $1 = dir with individual fasta files
# $2 = dereplicated fasta file

echo $1
echo $2

cat $1/*.fasta | grep -v "^>" | grep -v [^ACGTacgt] | sort -d | uniq -c | while read abundance sequence ; do hash=$(printf "${sequence}" | sha1sum); hash=${hash:0:40};printf ">%s;size=%d;\n%s\n" "${hash}" "${abundance}" "${sequence}"; done > $3 2> /dev/null 



