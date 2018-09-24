#!/bin/bash
# 23 Sept 2018
# A. Vershinina
# Goal: sample equal number of snps from bins. Each bin is a certain SF (source file) and AC (allele count).

# AC has 6 conditions: 2,3,4,5,6,7.
# SF has a ton of conditions, each one is different, according to AC. 
# If I want to sample let's say 1M variants, they should be equally distributed across ACs. Which is 167k from each AC bin.
# Bins in ACs (if working with four genome files in vcf):
# AC2 - 10 SF types
# AC3 - 10
# AC4 - 11
# AC5 - 5 
# AC6 - 5
# AC7 - 1 
# Other ACs are not interesting bcs, f.ex. AC=1 - rare or errors, with 4 genomes AC=8 means fixed differences with the reference.
# Important: need a file with variant counts. Create this file by: 
# zcat file.vcf.bgz | awk 'BEGIN {OFS="\t" ; FS="\t"}; {print $1, $2, $8}' > variant_counts.tab
# cat variant_counts.tab | awk -F ";" '$1=$1' OFS="\t" > file.counts.tab

# Then create files with types of SF like so:
# for a in {1..10}; do cat  file.counts.tab | grep AC=$a | cut -f 7 | sort | uniq > $a.ac.txt; done

# USAGE: script.sh vcffile.vcf.GZ

TARGET=167000 # change according to needs
ACf='ACs/' # folder with $a.ac.txt

for AC in {2..7}; do
	echo 'Allele count:' $AC
	nlines=$(cat ${ACf}/${AC}.ac.txt | wc -l)
	echo 'Lines to divide tagret:' $nlines
	N=$((TARGET / nlines))
	echo 'Lines to sample:' $N
	for SF in $(cat ${ACf}/${AC}.ac.txt); do
		echo 'Sample File subsetting:' $SF
		sfn=$(printf '%s' "$SF" | tr -d ',=')
		echo 'Sample file naming:' $sfn
		zcat $1 | grep AC=${AC} | grep $SF | shuf -n $N | gzip > shufed/${AC}.${sfn}.vcf.gz
	done
done

zcat shufed/*.vcf.gz > shufed/shufed.vcf
