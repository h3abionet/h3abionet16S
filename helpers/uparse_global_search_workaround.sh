#!/bin/bash

# $1 = fasta input file 
# $2 = dir to split file into chunks
# $3 = representative OTU fasta set
# $4 = percentage identity (float e.g. 0.97)
# $5 = strand (string e.g. plus)
# $6 = combined OTU UPARSE table 

# Should we make this?
mkdir $2
cd $2

fasta-splitter.pl -n-parts-total 100 -out-dir $2 $1
for i in $(ls $2/*.fa);
  do usearch8 -usearch_global $i -db $3 -id $4 -strand $5 -uc $i.map.uc;
done 

cat $2/*.map.uc > $6
