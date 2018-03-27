#!/usr/local/bin/bash
# 27 March 2018
# A. Vershinina
# Goal: count reads in many fastq
# Change grep parameter for your specific file extension

FILES=*.fastq.gz

for f in ${FILES}; do
	echo -n "$f : "; zcat $f | grep '@ERR' | wc -l
	wait
done

