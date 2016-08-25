#!/bin/bash

# $1 = sample_id
# $2 = fw_read
# $3 = rv_read
# $4 = fw_read_renamed
# $5 = rv_read_renamed

if [ -z "$TMPDIR" ]; then
    TMPDIR=/tmp
fi

echo $1
echo $2
echo $3
echo $4
echo $5
echo $TMPDIR

# fastx_toolkit needs to be setup in PATH

# Sort out forward read
basename=`basename $2`
fastx_renamer -Q33 -n COUNT -i $2 -o $TMPDIR/${basename}_tmp
sed "s/^\(@\|+\)\([0-9]*\)$/\1$1\2;barcodelabel=$1\/1/" $TMPDIR/${basename}_tmp > $TMPDIR/${basename}_renamed
rm -f $TMPDIR/${basename}_tmp
mv $TMPDIR/${basename}_renamed $4

# Sort out reverse read
basename=`basename $3`
fastx_renamer -Q33 -n COUNT -i $3 -o $TMPDIR/${basename}_tmp
sed "s/^\(@\|+\)\([0-9]*\)$/\1$1\2;barcodelabel=$1\/1/" $TMPDIR/${basename}_tmp > $TMPDIR/${basename}_renamed
rm -f $TMPDIR/${basename}_tmp
mv $TMPDIR/${basename}_renamed $5
