#!/usr/local/bin/bash
# 21 Feb 2018
# A. Vershinina
# Goal: AntCaller outputs vcf file without header (i. e. the file has only variants). To process this file we need vcf formatting with the corresponding info.
# Create a file vcf_header.txt. This can contain vcf header created by another program from the same BAM file, such as mpileup. Or any other header of your choice. GZIP the header file!
# Example:
# head -n 40 samtoolsgenerated.vcf > vcf_header.txt
# sed -i '/INDEL/d' vcf_header.txt
# sed -i '/samtool/d' vcf_header.txt
# gzip vcf_header.txt

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh vcf_header.txt.gz"
    exit 1
fi

FILES=*.ant.vcf.gz
FIXVCF='java -jar /soe/avershinina/tools/jvarkit/dist/fixvcf.jar'

for f in $FILES
do
	NAME=$(echo ${f} | sed 's/[.].*//')
	wait
	zcat $1 $f > tmp && mv tmp ${NAME}.tmp.vcf
	wait
	$FIXVCF < ${NAME}.tmp.vcf | vcf-sort | bgzip > ${NAME}.ant.h.vcf.bgz
	wait
	rm -f ${NAME}.tmp.vcf
	wait
	tabix -p vcf ${NAME}.ant.h.vcf.bgz
	wait
	echo "Sample $f done"
done
wait
echo "Reheader, bgzip and tabix done"
