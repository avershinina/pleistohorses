#!/bin/bash
# A. Vershinina
# 25 Jan 2018
# Goal: Run pca projecting one panel into another.
# Solution was found here https://groups.google.com/forum/#!topic/plink2-users/NplJ88jjMOU
# Usage: script.sh samples.txt

if [ "$#" -lt 1 ] # are there less than 2 arguments?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh samplenames.txt"
    exit 1
fi

echo "script name: $0"
echo "processing samples from: $1"

# arg 1  - file with sample names, each sample name starts from a new line.

#--------------
# variables
#--------------
DATE=`date +%Y-%m-%d`
mkdir vcf2structure-no-mdrn-projection-$DATE
VCFTOOLS='path' 
BGZIP='/path/to'
TABIX='/path/to'
OUT='vcf2structure-projection-'$DATE
IN='/path/to'
PLINK='/path/plink2'
BCFTOOLS='path/bcftools'
#--------------
# Remove samples
#--------------
echo "Starting sample purge"
for SAMPLE in $(cat $1); do
	$VCFTOOLS --vcf ${SAMPLE}.vcf --out ${SAMPLE}.no.mdrn --remove remove_modern.txt --stdout --recode --recode-INFO-all | ${BGZIP} > ${SAMPLE}.no.mdrn.vcf.bgz
done

#--------------
# Update header
#--------------
echo "Starting indexing and reheading with TABIX"
for SAMPLE in $(cat $1); do
	${TABIX} -p vcf ${SAMPLE}.no.mdrn.vcf.bgz
	${TABIX} -r header.v2.txt ${SAMPLE}.no.mdrn.vcf.bgz > ${SAMPLE}.no.mdrn.rehead.vcf.bgz
	rm ${SAMPLE}.no.mdrn.vcf.bgz
	${TABIX} -p vcf ${SAMPLE}.no.mdrn.rehead.vcf.bgz
done
echo "TABIX done"
#--------------
# Subset
#--------------
echo "Starting BCFTOOLS subsetting"
## samples_bad.txt and samples_good.txt are vice versa actually
## --set-id is used to define snp IDs
for SAMPLE in $(cat $1); do
	${BCFTOOLS} view -Ov -S samples_bad.txt --min-af 0.01 --max-af 0.99 ${SAMPLE}.no.mdrn.rehead.vcf.bgz > ${SAMPLE}.no.mdrn.ref.panel.vcf
	${BCFTOOLS} annotate -Ov --set-id +'%CHROM\_%POS' ${SAMPLE}.no.mdrn.ref.panel.vcf > ${SAMPLE}.no.mdrn.ref.panel.setid.vcf
done

for SAMPLE in $(cat $1); do
	${BCFTOOLS} view -Ov -S samples_good.txt --min-af 0.005 --max-af 0.99 ${SAMPLE}.no.mdrn.rehead.vcf.bgz > ${SAMPLE}.no.mdrn.shitty.panel.vcf
	${BCFTOOLS} annotate -Ov --set-id +'%CHROM\_%POS' ${SAMPLE}.no.mdrn.shitty.panel.vcf > ${SAMPLE}.no.mdrn.shitty.panel.setid.vcf
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done

echo "Subsetting done"

#--------------
# Project
#--------------

echo "Start projecting"

# Freq for ref

for SAMPLE in $(cat $1); do
	${PLINK} --vcf ${SAMPLE}.no.mdrn.ref.panel.setid.vcf --freq --pca var-wts --out ${SAMPLE}.pca_reference
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done

# Recompute using freqs

for SAMPLE in $(cat $1); do
	${PLINK} --vcf ${SAMPLE}.no.mdrn.shitty.panel.setid.vcf --read-freq ${SAMPLE}.pca_reference.afreq --score ${SAMPLE}.pca_reference.eigenvec.var 2 3 header-read no-mean-imputation variance-normalize --score-col-nums 5-14 --out ${SAMPLE}.pca_proj_shitty
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done
	
# Make PCs comparable
for SAMPLE in $(cat $1); do
	${PLINK} --vcf ${SAMPLE}.no.mdrn.ref.panel.setid.vcf --read-freq ${SAMPLE}.pca_reference.afreq --score ${SAMPLE}.pca_reference.eigenvec.var 2 3 header-read no-mean-imputation variance-normalize --score-col-nums 5-14 --out ${SAMPLE}.pca_proj_reference
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
done

echo "All done"

mv *panel* ${OUT}/
