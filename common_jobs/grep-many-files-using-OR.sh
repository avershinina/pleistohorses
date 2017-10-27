#!/bin/bash

for i in *Q.trf.rpt.mskr.filtered.snp

do

echo "Subsetting: "$i        

grep -E 'chr10|chr11|chr12|chr13|chr14|chr15' $i > $i".subsampled"

done