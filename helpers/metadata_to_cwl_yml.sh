#!/bin/bash

# $1 = metadata_file 
# $2 = cwl_yml

( echo "fastqSeqs:"; awk ' NR>1 { print " - forward:\n     class: File\n     path: " $2 "\n   reverse:\n     class: File\n     path: " $3 "\n   sample_id: " $1 "\n   barcode_sequence: " $4 "\n   linker_primer_sequence: " $5 "\n   reverse_primer: " $6 "\n   dog_breed: " $7 "\n   treatment: " $8} ' < $1 ) > $2 


