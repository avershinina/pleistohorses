#!/usr/local/bin/bash
# 25 Apr 2018
# A. Vershinina
# Goal: smart split of multisample vcf produced by GATK. 
# This allows to split DP field such that it is not multisample DP (i.e. very high), but an actual DP per sample.

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh yourfile.vcf"
    exit 1
fi

REF=/path/ref.fasta
GATK=/tools/GenomeAnalysisTK.jar
for sample in `bcftools query -l ${1}`; do
	java -jar ${GATK} -T SelectVariants -R ${REF} -V ${1} -o ${sample}.split.vcf -sn ${sample} --excludeNonVariants --selectTypeToExclude INDEL
done

wait

for sample in *.split.vcf; do
	bgzip ${sample}.split.vcf
	wait
	tabix ${sample}.split.vcf.gz
	wait
done
