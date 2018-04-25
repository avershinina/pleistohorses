#!/usr/local/bin/bash
# 15 April 2018
# A. Vershinina
# Goal: filter out multiallelic sites and indels from files produced by different genotype callers.
# bcftools view --max-alleles 2 --exclude-types indels input.vcf.gz
# To run this script you first need to calculate coverage distribution and DP cutoff.
# To estimate coverage cutoff run this https://github.com/avershinina/pleistohorses/blob/master/variant_calling/estimate_coverage_distribution_and_quantile.sh

OUT=/biallelic_no_indels
IN=/variant_discovery
DPs=/variant_discovery/cov_distribution_DP_cutoff

cd $IN
AFILES=*.ant.h.vcf.bgz
MFILES=*.mpile.vcf.gz
GFILES=*.gatk.vcf.gz

for f in ${AFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	maxDP=$(cat "${DPs}/${NAME}.cov.0.995.q.txt")
	bcftools view --max-alleles 2 --exclude-types indels  --include "DP < $maxDP" ${IN}/${f} --output-type z > ${NAME}.ant.bi.snps.DP${maxDP}.vcf.gz
	wait
	tabix ${NAME}.ant.bi.snps.DP${maxDP}.vcf.gz
	wait
	echo "Biallelic sites, no indels, max DP > 0.995 quantile filtering: $f done">> filtering.bi.snps.log
	wait
done

for f in ${MFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	maxDP=$(cat "${DPs}/${NAME}.cov.0.995.q.txt")
	bcftools view --max-alleles 2 --exclude-types indels  --include "DP < $maxDP" ${IN}/${f} --output-type z > ${NAME}.mpile.bi.snps.DP${maxDP}.vcf.gz
	wait
	tabix ${NAME}.mpile.bi.snps.DP${maxDP}.vcf.gz
	wait
	echo "Biallelic sites, no indels, max DP > 0.995 quantile filtering: $f done">> filtering.bi.snps.log
	wait
done

for f in ${GFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	maxDP=$(cat "${DPs}/${NAME}.cov.0.995.q.txt")
	bcftools view --max-alleles 2 --exclude-types indels  --include "DP < $maxDP" ${IN}/${f} --output-type z > ${NAME}.gatk.bi.snps.DP${maxDP}.vcf.gz
	wait
	tabix ${NAME}.gatk.bi.snps.DP${maxDP}.vcf.gz
	wait
	echo "Biallelic sites, no indels, max DP > 0.995 quantile filtering: $f done">> filtering.bi.snps.log
	wait
done

mv *.bi.snps.* ${OUT}/
