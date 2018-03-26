#!/usr/local/bin/bash
# 26 Matrch 2018
# A. Vershinina
# Goal: Run bedtools genomecov and quantile catcher.

FILES=*.bam
REF_INFO=/path/genome.info

for f in $FILES; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	bedtools genomecov -ibam ${f} -g ${REF_INFO} > ${NAME}.cov.tab
	wait
	echo "File $f bedtools coverage computed"
done

for f in $FILES; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	Rscript catch_quantile.R ${NAME}.cov.tab 0.995
	wait
	echo "File $f quantile computed"
done

mkdir cov_distribution_DP_cutoff
mv *.cov.tab cov_distribution_DP_cutoff/
mv *q.txt cov_distribution_DP_cutoff/
