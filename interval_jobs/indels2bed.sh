#!/usr/local/bin/bash
# 4 April 2018
# A. Vershinina
# Goal: get intervals with indels using vcf file
# if bedops is not working: use export PATH=${PATH}:/soe/avershinina/tools/bedops
# works under /bin/bash
# gzipped vcfs will not work, if gzipped - use zcat and piping.


if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh variants.vcf"
    exit 1
fi


VCF2BED=/soe/avershinina/tools/bedops/vcf2bed

NAME=$(echo ${1} | sed 's/[.].*//')
$VCF2BED --deletions < $1 > ${NAME}.delets.bed
# zcat $1 | $VCF2BED --deletions > ${NAME}.delets.bed
wait
echo "Deletions converted to bed"
$VCF2BED --insertions < $1 > ${NAME}.inserts.bed
wait
echo "Insertions converted to bed"

echo "Done"
