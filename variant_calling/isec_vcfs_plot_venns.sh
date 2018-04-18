#!/usr/local/bin/bash
# 12 Apr 2018
# A. Vershinina
# Goal: intersect call sets, leaving Ant as a backbone
# Prerequisite: https://github.com/jlaw9/TRI_Dev/blob/1ae72b9e7f1a6820e6f45998f461173f6f5a5725/Stats/write_venns.py
# And the Venn.R script from the same repo.

WV=write_venns.py

AFILES=*.ant.bi.snps.*.vcf.gz
MFILES=*.mpile.bi.snps.*.vcf.gz
GFILES=*.gatk.bi.snps.*.vcf.gz
OUT=/projects/redser3-notbackedup/projects/alisa_beringia/variant_discovery/venns_btw_samples

for f in ${AFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	gzip -d $f -c > ${OUT}/${NAME}.ant.vcf
	echo "Unzipping $f done"
	wait
done

for f in ${MFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	bgzip -d $f -c > ${OUT}/${NAME}.mpile.vcf
	echo "Unzipping $f done"
	wait
done

for f in ${GFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	bgzip -d $f -c > ${OUT}/${NAME}.gatk.vcf
	echo "Unzipping $f done"
	wait
done

cd $OUT

for f in ${GFILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	python $WV -v ${NAME}.ant.vcf -v ${NAME}.mpile.vcf -v ${NAME}.gatk.vcf -o ${NAME}.isec 
	echo "Intersecting ${NAME} done"
	wait
done
