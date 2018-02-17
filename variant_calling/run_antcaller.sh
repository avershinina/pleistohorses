#!/usr/local/bin/bash
# 16 Feb 2018
# A. Vershinina
# Goal: For one sample run AntCaller tool
# TODO: add filter of outrageously incorrect calls.
# Important: AntCaller needs .py files to be in the same directosy as BAMs.

if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh yourfile.bam"
    exit 1
fi


NAME=$(echo ${1} | sed 's/[.].*//') # Get sample name from filename. This sed commend removes everything after the first dot.
SAMTOOLS=/PATH/samtools-1.7/bin/samtools

echo "script name: $0"
echo "Start processing BAM file: $1"

${SAMTOOLS} view -h $1 | python AntCaller-1.1.py --pileup -o ${NAME}.ant
echo "Pileup created: " ${NAME}.ant.AntCaller.pileup

${SAMTOOLS} view -h $1 | python AntCaller-1.1.py --extract -o ${NAME}.ant
echo "Damage info extracted: " ${NAME}.ant.damageinfo

python AntCaller-1.1.py --snpcalling -o ${NAME}.ant -d ${NAME}.ant.damageinfo -f ${NAME}.ant.AntCaller.pileup --thread 10
