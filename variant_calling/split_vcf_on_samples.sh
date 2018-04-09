#!/usr/local/bin/bash
# 9 April 2018
# A. Vershinina
# Goal: get individual files from multisample vcf

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh variants.vcf"
    exit 1
fi

BSFTOOLS=/path/...

for file in $1; do
# for file in *.vcf*; do
	for sample in `bcftools query -l $file`; do
		NAME=$(echo "$sample")
		$BCFTOOLS view -c1 -Oz --samples $sample -o ${NAME}.gatk.vcf.gz $file
	done
done
