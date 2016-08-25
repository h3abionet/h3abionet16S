#!/bin/bash

# $* = individual array of fasta files

cat $* | grep -v "^>" | grep -v [^ACGTacgt] | sort -d | uniq -c | \
while read abundance sequence ; do hash=$(printf "${sequence}" | sha1sum);\
 hash=${hash:0:40};printf ">%s;size=%d;\n%s\n" "${hash}" "${abundance}" "${sequence}"; done > derep.fasta
