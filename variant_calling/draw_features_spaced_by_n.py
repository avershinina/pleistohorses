#!/usr/bin/python
# 14 Sept 2018
# A. Vershinina
# Goal: take a BED file, containing snps.
# Draw from the file only those snps, that are spaced by more than N bp between each other.
# At! This now works regardless of chromosome number, so BED file should contain only elements of one chromosome.
import pandas as pd
f='file.bed'
snps2 = pd.read_csv(f, delimiter='\t', names = ["chr", "snp"])
# chrs=snps2.chr.unique()
prev = 0
for i, item in enumerate(snps2['snp']):
    value = int(item)
    l = value - prev
    if l > N: # change N to desired number of bp
        prev = value
        print(i,l) # TODO extract snps by index i
