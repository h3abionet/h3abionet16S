#!/bin/bash

# $* = individual array of fasta files

cat $* | awk '/^>/ {printf("%s%s\n",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' | \
grep -v "^>" | grep -v [^ACGTacgt] | sort -d | uniq -c | \
while read abundance sequence ; do hash=$(printf "${sequence}" | sha1sum);\
 hash=${hash:0:40};printf ">%s;size=%d;\n%s\n" "${hash}" "${abundance}" "${sequence}"; done > derep.fasta
