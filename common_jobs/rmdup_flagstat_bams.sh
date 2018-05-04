#!/usr/local/bin/bash
# 4 May 2018
# A. Vershinina
# Goal: remove duplicates from high coverage BAMs
# Usage: script.sh genome.bam

IN=/genomes

NAME=$(echo ${1} | sed 's/[.].*//')

# Remove duplicates and index
samtools rmdup -S ${IN}/${1} ${NAME}.rescaled.rmdup.bam
samtools index ${NAME}.rescaled.rmdup.bam
	wait

# Generate statistics like number mapped, duplicates, and number aligned to each chromosome
samtools flagstat ${IN}/${1} >& ${NAME}.rescaled.flagstats.txt
samtools flagstat ${NAME}.rescaled.rmdup.bam >& ${NAME}.rescaled.rmdup.flagstats.txt
samtools idxstats ${IN}/${1} >& ${NAME}.rescaled.idxstats.txt
samtools idxstats ${NAME}.rescaled.rmdup.bam >& ${NAME}.rescaled.rmdup.idxstats.txt

echo "Sample $1 processed"
