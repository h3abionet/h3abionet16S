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
for i in $(ls split/*.fasta);
  do usearch8 -usearch_global $i -db $3 -id $4 -strand $5 -uc split/$i.map.uc;
done 

cat split/*.map.uc > otus.mapped.uc
