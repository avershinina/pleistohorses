#!/bin/bash
IDs=$(cat $1) # file with a list of sequences you want to retain
FILES=*.fa.gz # EDIT
echo 'Retaining $IDs' 
for f in $FILES; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	for ID in $IDs; do
	zcat $f | awk '/'${ID}'/{flag=1;print $0;next}/^>/{flag=0}flag' >> ${NAME}.noXUn.fasta ## '>>' is dangerous, will need to chage
	wait
	done
	wait
done
