#!/usr/local/bin/bash
# 21 Feb 2018
# A. Vershinina
# Goal: Run freebayes on all samples
# Important: tbd

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh groupname"
    exit 1
fi


REF=/path/ref.fasta
BGZIP=/path/bgzip
TABIX=/path/tabix
FREEBAYES=/path/freebayes
VCFFILTER=/path/vcffilter
# BAMADDRG=/path/bamaddrg

echo "script name: $0"
echo "output prefix: $1"
# Options:
# --min-alternate-count Require at least this *count* of observations supporting an alternate allele within a single individual in order to evaluate the position.  default: 2


${FREEBAYES} -f $REF --min-alternate-count 5 --report-monomorphic fil1.bam file2.bam file3.bam | ${VCFFILTER} --info-filter "QUAL > 20" | vcfutils.pl varFilter -D 80 > ${1}.FB.vcf 

${BGZIP} ${1}.FB.vcf
${TABIX} -p vcf ${1}.FB.vcf.gz

# && DP<=${COV2} 
# -D ${COV2}
