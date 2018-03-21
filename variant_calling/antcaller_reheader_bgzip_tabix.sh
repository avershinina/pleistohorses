#!/usr/local/bin/bash
# 21 March 2018
# A. Vershinina
# Goal: AntCaller outputs vcf file without header (variants only). To process this file we need vcf formatting with info.
# Create a file vcf_header.txt. This should contain vcf header created by another program from the same BAM file, such as mpileup.  GZIP header!
# Example:
# head -n 40 samtoolsgenerated.vcf > vcf_header.txt
# sed -i '/INDEL/d' vcf_header.txt
# sed -i '/samtool/d' vcf_header.txt

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh vcf_header.txt.gz"
    exit 1
fi

FILES=*.ant.vcf.gz
FIXVCF='java -jar /soe/avershinina/tools/jvarkit/dist/fixvcf.jar'
PICARD='java -jar /soe/avershinina/tools/picard.jar'

for f in $FILES
do
	NAME=$(echo ${f} | sed 's/[.].*//')
	wait
	zcat $1 $f > tmp && mv tmp ${NAME}.tmp.vcf
	wait
	${FIXVCF} < ${NAME}.tmp.vcf > ${NAME}.tmp2.vcf 
	echo "$f FixVCF done"
	# | vcf-sort | bgzip > ${NAME}.ant.h.vcf.bgz
	wait
	${PICARD} SortVcf I=${NAME}.tmp2.vcf O=${NAME}.ant.h.vcf
	echo "$f PICARD SortVcf done"
	wait
	bgzip --stdout ${NAME}.ant.h.vcf > ${NAME}.ant.h.vcf.bgz
	tabix -p vcf ${NAME}.ant.h.vcf.bgz
	echo "$f bgzip, tabix done"
	wait
	rm -f ${NAME}.ant.h.vcf
	rm -f ${NAME}.tmp2.vcf
	rm -f ${NAME}.tmp.vcf
	echo "processing for Sample $f done"
done
wait
echo "Reheader, sorting, bgzip, and tabix done"
		
