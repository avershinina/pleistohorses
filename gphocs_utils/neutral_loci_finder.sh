# !/usr/local/bin/bash

# 26 Oct 2018
# A. Vershinina
# Goal: file processing from non-neutral regions to the set of neutral loci.

#########################
# usage script.sh -b nonneutral_regions.bed -g reference_genome_info.txt -r region_length -s step_length -o outfilename
#########################

# ref_genome_info is a text file looking like
# chrom	size
# chr1	185838109
# chrX	124114077
# chr2	120857687

# -r length of the region to be extracted for the final loci set.
# -s step to be used to space regions by MIN(s). Let's say you want regions of 1kb spaced by ate least 30kb. The would be -s 30000 -r 1000
# Remember that bed_from_bed works only if step>region.

# bed_from_bed.py is a script github.com/avershinina/pleistohorses/interval_jobs/bed_from_bed.py

# bedtools requires data sorted by chromosome and then by start position
# sort -k1,1 -k2,2n in.bed > in.sorted.bed 

# Assign arguments
while getopts b:g:r:s:o: option
do
case "${option}"
in
b) BED=${OPTARG};;
g) REF=${OPTARG};;
r) REGION=${OPTARG};;
s) STEP=$OPTARG;;
o) OUT=$OPTARG;;
esac
done

mkdir ${OUT}_outdir
OUT_DIR=${OUT}_outdir

# Sort for bedtools
sort -k1,1 -k2,2n $BED > ${OUT_DIR}/${BED}.sorted

# Make an inverse of nonneutral regions, i.e. create a guide bed file.

bedtools complement -i ${OUT_DIR}/${BED}.sorted -g $REF > ${OUT_DIR}/${BED}.complemented

# Merge features that are too close to each other. Remember that bed_from_bed works only if step>region. Thus merge parameter -d should be the same as region length+1 

bedtools merge -i ${OUT_DIR}/${BED}.complemented -c 1 -o count -d $REGION

# 