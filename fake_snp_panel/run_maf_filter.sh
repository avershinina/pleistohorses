#!/usr/local/bin/bash
# 8 Mar 2018
# A. Vershinina
# Goal: run maf filters creating several vcf files

# maf filters
# here 440 is the number of haplotypes
M1=0.00227272727273 # 1/440
M25=0.0568181818182 # 25/440
M50=0.113636363636 # 50/440
M150=0.340909090909 # 150/440

vcftools --vcf mDNA.100k.vcf --recode --maf ${M1} --out maf_filtered/mDNA.100k.M1
wait
vcftools --vcf mDNA.100k.vcf --recode --maf ${M25} --out maf_filtered/mDNA.100k.M25
wait
vcftools --vcf mDNA.100k.vcf --recode --maf ${M50} --out maf_filtered/mDNA.100k.M50
wait
vcftools --vcf mDNA.100k.vcf --recode --maf ${M150} --out maf_filtered/mDNA.100k.M150
