#!/usr/local/bin/bash
# 23 Mar 2018
# A. Vershinina
# Goal: Run vcf stats on few files generated by different genotype callers. 

MFILES=*mpile.vcf.gz
AFILES=*ant.h.vcf.bgz
BCFTOOLS=/path/bcftools
PLOTS=/path/plot-vcfstats
OUT_DIR=/path/plots
REF=/path/ref.fasta

for f in ${MFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	${BCFTOOLS} stats -F ${REF} ${f} > ${NAME}.mplie.stats
	${PLOTS} -p ${OUT_DIR}/${NAME}.mpile ${NAME}.mplie.stats
done

for f in ${AFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	${BCFTOOLS} stats -F ${REF} ${f} > ${NAME}.ant.stats
	${PLOTS} -p ${OUT_DIR}/${NAME}.ant ${NAME}.ant.stats
done
