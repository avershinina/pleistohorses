#!/usr/bin/python
# 14 Sept 2018
# A. Vershinina
# Goal: take a BED file, containing snps.
# Draw from the file only those snps, that are spaced by more than N bp between each other.
# At! This now works regardless of chromosome number, so BED file should contain only elements of one chromosome.
f='path/test_2.bed'
import pandas as pd
snps = pd.read_csv(f, delimiter='\t', names =  ["chr", "snp"])
prev = 0
df = pd.DataFrame(columns=["chr", "snp"]) # new df to save snips
a_list=[]
for i, item in enumerate(snps['snp']):
    value = int(item)
    l = value - prev
    if l > N: # change to desired number
        a_list.append(value)
        prev = value
        print(i,l)
        print(a_list)
df = pd.DataFrame({'chr': snps.chr[1], 'snp': a_list})
del a_list
df.to_csv("path/filtered.bed", encoding='utf-8', index=False, header=False, sep='\t')
