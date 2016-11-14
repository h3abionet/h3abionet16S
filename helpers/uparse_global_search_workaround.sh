#!/bin/bash

# $1 = fasta input file 
# $2 = representative OTU fasta set
# $3 = percentage identity (float e.g. 0.97)
# $4 = strand (string e.g. plus)

if [ ! -d split ];
 then
   mkdir split
fi

fasta-splitter.pl -n-parts-total 100 -out-dir split $1

cd split

for i in $(ls *.fasta);
  do usearch -usearch_global $i -db $2 -id $3 -strand $4 -uc $i.uc;
done 

cat *.uc > ../otus.uc
