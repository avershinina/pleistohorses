#!/bin/bash
# A. Vershinina
# 23 Jan 2018
# Goal: get all the files necessary for structure analysis
# Usage: script.sh samples.txt

if [ "$#" -lt 1 ] # are there less than 2 arguments?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh samplenames.txt"
    exit 1
fi

echo "script name: $0"
echo "processing samples from: $1"

# arg 1  - file with sample names, each sample name starts from a new line

#--------------
# variables
#--------------
DATE=`date +%Y-%m-%d`
mkdir vcf2structure-$DATE
VCFTOOLS='/your/path/vcftools' 
BGZIP='/your/path'
TABIX='/your/path'
OUT='/vcf2structure-'$DATE
IN='/your/path'
PLINK='/your/path'

#--------------
#  Filter
#--------------

echo "Starting MAF filtering"
for SAMPLE in $(cat $1); do
	$VCFTOOLS --vcf ${SAMPLE}.vcf --maf 0.001 --out ${SAMPLE}.maf0.001 --recode --recode-INFO-all --stdout | ${BGZIP} > ${SAMPLE}.maf0.001.vcf.bgz
done

echo "MAF filtering done"

#--------------
# Reheader
#--------------
echo "Starting indexing and reheading with TABIX"
for SAMPLE in $(cat $1); do
	${TABIX} -p vcf ${SAMPLE}.maf0.001.vcf.bgz
	${TABIX} -r header.txt ${SAMPLE}.maf0.001.vcf.bgz > ${SAMPLE}.maf0.001.rehead.vcf.bgz
	rm ${SAMPLE}.maf0.001.vcf.bgz
	${TABIX} -p vcf ${SAMPLE}.maf0.001.rehead.vcf.bgz
done
echo "TABIX done"

#--------------
# To plink 
#--------------
echo "Starting conversion to PLINK file format"
for SAMPLE in $(cat $1); do
	$VCFTOOLS --gzvcf ${SAMPLE}.maf0.001.rehead.vcf.bgz --plink --out ${SAMPLE}.maf0.001
done

#--------------
# params 
#--------------
echo "Creating .pedind file"
for SAMPLE in $(cat $1); do
	cat ${SAMPLE}.maf0.001.ped | cut -f1-6 > ${SAMPLE}.maf0.001.tmp
	cat ${SAMPLE}.maf0.001.ped | cut -c 1,2 | paste ${SAMPLE}.maf0.001.tmp - > ${SAMPLE}.maf0.001.pedind
	rm ${SAMPLE}.maf0.001.tmp
done
echo ".pedind created"

#--------------
# make bed
#--------------

echo "Creating bed file"
for SAMPLE in $(cat $1); do
	$PLINK --allow-extra-chr --autosome --vcf ${SAMPLE}.maf0.001.rehead.vcf.bgz --make-bed --out ${SAMPLE}.maf0.001
done
echo "bed files are created"

#--------------
# run pca v1
#--------------

echo "Running PCA using plink"
for SAMPLE in $(cat $1); do
	$PLINK --vcf ${SAMPLE}.maf0.001.rehead.vcf.bgz --allow-extra-chr  --pca 3 --out ${SAMPLE}.plink.pca
done
echo "Plink PCA finished"

#--------------
# create param file for smartpca
#--------------
echo "Param file is creating"
for SAMPLE in $(cat $1); do
	echo "genotypename: "	${SAMPLE}.maf0.001.ped >> ${SAMPLE}.param 
	echo "snpname: "	${SAMPLE}.maf0.001.map >> ${SAMPLE}.param
	echo "indivname: "	${SAMPLE}.maf0.001.pedind >> ${SAMPLE}.param
	echo "evecoutname: "	${SAMPLE}.evec >> ${SAMPLE}.param
	echo "evaloutname: "	${SAMPLE}.eval >> ${SAMPLE}.param
	echo "deletesnpoutname: "	${SAMPLE}.snpremoved >> ${SAMPLE}.param
	echo "outlieroutname: "	${SAMPLE}.ind_outliers >> ${SAMPLE}.param
	echo "lsqproject: NO" >> ${SAMPLE}.param
	echo "outliermode: 0" >> ${SAMPLE}.param
done
echo "param file is created"

mv *maf* $OUT

# The EIGENSOFT smartpca needs four input files: The ‘.ped’ (containing the genotype information) and ‘.map’ (containing the chromosome/position information) files that we exported above, a ‘.pedind’ file containing individual information, and a ‘.par’ file with the specified parameters for analysis.
# details https://github.com/chrchang/eigensoft/blob/master/POPGEN/README

