#!/usr/local/bin/bash
# 21 Feb 2018
# A. Vershinina
# Goal: Run mpileup
# Important: tba

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh yourfile.bam"
    exit 1
fi


NAME=$(echo ${1} | sed 's/[.].*//') # Get sample name from filename. This line strips everything after the first dot.
SAMTOOLS=/path/samtools
BCFTOOLS=/path/bcftools
BGZIP=/path/bgzip
TABIX=/path/tabix

REF=/path/ref.fasta

echo "script name: $0"
echo "Start mpileup for BAM file: $1"

# Options:
# --adjust-MQ Coefficient for downgrading mapping quality for reads containing excessive mismatches. 
# --no-BAQ Disable probabilistic realignment for the computation of base alignment quality (BAQ).
# --min-MQ Minimum mapping quality for an alignment to be used
# --min-BQ Minimum base quality for a base to be considered
# --count-orphans Do not skip anomalous read pairs in variant calling. 
# --ignore-RG Ignore RG tags
# --SnpGap filter SNPs within <int> base pairs of an indelth
# -D max read depth
# to not call monomorphic sites use bcftools --variants-only 

#GENOME_SIZE=$(samtools view -H ${1} | grep -P '^@SQ' | cut -f 3 -d ':' | awk '{sum+=$1} END {print sum}')
# Estimate coverage and cut off
COV=$(samtools depth ${1} | awk '{sum+=$3} END { print sum/185838109}') # 185838109 chromosome size
COV2=$(echo "${COV}*2.5" | bc)

echo "Coverage SNP DP cut off: " ${COV2}

${SAMTOOLS} mpileup --skip-indels --count-orphans --adjust-MQ 50 --no-BAQ --min-MQ 20 --min-BQ 20 --ignore-RG --uncompressed --fasta-ref ${REF} ${1} | ${BCFTOOLS} call --multiallelic-caller | ${BCFTOOLS} filter --SnpGap 5 --skip-variants indels --include '%QUAL>=20 && DP>=5' | vcfutils.pl varFilter -D 100 > ${NAME}.mpile.vcf
wait

${BGZIP} ${NAME}.mpile.vcf
${TABIX} -p vcf ${NAME}.mpile.vcf.gz

# && DP<=${COV2} 
# -D ${COV2}
