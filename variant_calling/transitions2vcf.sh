#!/usr/local/bin/bash
# 3 Apr 2018
# A. Vershinina
# Goal: convert transitions to a vcf file
# by https://www.biostars.org/p/287667/

TiFILTER="java -jar ~/tools/jvarkit/dist/vcffilterjdk.jar -e 'return variant.isSNP() && variant.isBiallelic() && VariantContextUtils.isTransition(variant);'"


FILES=*.vcf.gz

for f in ${FILES}; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	$TiFILTER $f > ${NAME}.Ti.vcf
	echo "Tv vcf for $f made"
	wait
done
