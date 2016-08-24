#!/bin/bash

for i in $1/*
do
	j=`basename $i .png`
	k=`dirname $i`
	convert -contrast -thumbnail 110 "$i" $k/thumb.$j.png
done
