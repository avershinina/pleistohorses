#!/bin/bash
#
# a very dirty way to remove sex chromosomes and chrUn from BAM file
# BAM header is not updated in this case, so use this script on your own risk
# found on biostars
RAW_DIR=/your/dir/here
PROCESSING_OUTPUT=/your/out/here

for SAMPLE in $(cat genomes-to-clean.txt) ; do
	samtools idxstats ${RAW_DIR}/${SAMPLE}.bam | cut -f 1 | grep -v 'chrX\|chrUn' | xargs samtools view -b ${RAW_DIR}/${SAMPLE}.bam > ${PROCESSING_OUTPUT}/${SAMPLE}.noXYUn.bam
	wait
done
echo "cleaned!"
