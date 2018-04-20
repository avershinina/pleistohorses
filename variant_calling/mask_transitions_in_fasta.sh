#!/usr/local/bin/bash
# 20 April 2018
# A. Vershinina
# Goal: Mask transitions in consensus fasta file

FILTER='java -jar /soe/avershinina/tools/jvarkit/dist/vcffilterjdk.jar'
VCFs=/path
TIs=/path/Ti_only

CONSENSI=/path/iupac_consensi
aFILES=*isec0_1.vcf.gz
for f in $aFILES; do
	NAME=$(echo ${f} | sed 's/[.].*//')
	wait
	$FILTER -e 'return variant.isSNP() && variant.isBiallelic() && VariantContextUtils.isTransition(variant);' ${VCFs}/$f > ${TIs}/${NAME}.Ti.vcf
	echo "Transitions converted for file $f"
	wait
	maskFastaFromBed -fi ${CONSENSI}/${NAME}.vcf.consensus.fa -fo ${CONSENSI}/${NAME}.vcf.consensus.masked.fa -bed ${TIs}/${NAME}.Ti.vcf
	echo "Fasta masked for sample $NAME"
done
echo "All done"
