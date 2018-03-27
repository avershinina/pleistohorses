#!/usr/local/bin/bash

# 19 March 2018
# A. Vershinina
# Goal: trim adapters and do QC on trimmed reads.
## Copypaste: Note that by default, AdapterRemoval does not require a minimum number of bases overlapping with the adapter sequence, before reads are trimmed. This may result in an excess of very short (1 - 3 bp) 3' fragments being falsely identified as adapter sequences, and trimmed. This behavior may be changed using the --minadapteroverlap option, which allows the specification of a minimum number of bases (excluding Ns) that must be aligned to carry trimming. For example, use --minadapteroverlap 3 to require an overlap of at least 3 bp.

## Get filenames
FILES=*.fastq.gz

## Set env-s
AR=/soe/avershinina/tools/adapterremoval-2.1.7/bin/AdapterRemoval
FQC=/soe/avershinina/tools/FastQC/fastqc

## trim adapters
### Remove Ns, min quality phred 20, filter out reads shorter than 25 bp

for f in $FILES
do
	SAMPLE=$(echo ${f} | sed 's/[.].*//')
	$AR --file1 $f --basename ${SAMPLE} --minadapteroverlap 3 --trimns --trimqualities --minquality 20 --minlength 25 --threads 10 --gzip
	echo "file $f done"
done
echo "trimming finished"

## FastQC

for f in $FILES
do
	SAMPLE=$(echo ${f} | sed 's/[.].*//')
	$FQC ${SAMPLE}.truncated.gz
	echo "file ${SAMPLE} QC done"
done
echo "FastQC done"

Rscript adapter_removal_summary_stat.R # collect how many reads were retained after trimming
