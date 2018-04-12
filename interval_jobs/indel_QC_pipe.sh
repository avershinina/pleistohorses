#!/usr/local/bin/bash
# 5 Apr 2018
# A. Vershinina
# Goal: pipeline indel QC process
# if vcf2bed is not working: use "export PATH=${PATH}:/soe/avershinina/tools/bedops"
# works under /bin/bash
if [ "$#" -lt 1 ] # are there less than 1 argument?
then
    echo "error: too few arguments, you provided $#, 1 required"
    echo "usage: script.sh variants.vcf"
    exit 1
fi

# Convert indels to bed format
# Outputs two files: indels and delets
./indels2bed.sh $1

# Collect start and end data 
# Outputs 
#'starts_inserts.txt'
#'starts_delets.txt'
#'ends_inserts.txt'
#'ends_delets.txt'
python collect_starts_ends.py

# remove the first line starts
sed -i '1d' starts_inserts.txt
sed -i '1d' starts_delets.txt
# remove last line from a ends
sed -i '$ d' ends_inserts.txt
sed -i '$ d' ends_delets.txt

# Calculate distances and plot histograms

Rscript histo_distances_btw_features.R

echo "Indel QC done"
