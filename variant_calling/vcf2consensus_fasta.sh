#!/usr/local/bin/bash
# 21 Feb 2018
# A. Vershinina
# Goal: filter out indels and create consensus fasta from reference + variants from vcf
# Important: this will include iupac codes at heterozygous sites

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh yourfile.bam"
    exit 1
fi

NAME=$(echo ${1} | sed 's/[.].*//') # Get sample name from filename. This line strips everything after the first dot.
BCFTOOLS=/path/bcftools
VCFTOOLS=/path/vcftools
REF=/path/ref.fa
BGZIP=/path/bgzip
TABIX=/path/tabix
echo "script name: $0"
echo "Start creating consensus for VCF file: $1"

$VCFTOOLS --gzvcf $1 --remove-indels --recode --recode-INFO-all --out ${NAME}.SNPs_only
$BGZIP ${NAME}.SNPs_only.recode.vcf
${TABIX} -p vcf ${NAME}.SNPs_only.recode.vcf.gz

$BCFTOOLS consensus --fasta-ref $REF --iupac-codes ${NAME}.SNPs_only.recode.vcf.gz > ${NAME}.vcf.consensus.fa
