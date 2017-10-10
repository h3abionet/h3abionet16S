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

# The nextline is just a hack for now to get Nextflow to be able to access the $db
db=`readlink -f $2`

for i in $(ls *.fasta);
  do usearch -usearch_global $i -db $db -id $3 -strand $4 -uc $i.uc;
done

cat *.uc > ../otus.uc
