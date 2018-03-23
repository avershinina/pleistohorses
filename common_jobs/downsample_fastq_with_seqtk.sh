#!/usr/local/bin/bash
# 23 Mar 2018
# A. Vershinina
# Goal: Downsample fastq files to a certain number of reads. 
SEQTK=/soe/avershinina/tools/seqtk/seqtk
FILES=*trim.truncated.gz

for f in ${FILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	${SEQTK} sample $f 6000000 | gzip > ${NAME}.6M.fq.gz
	echo "File $f done"
done
