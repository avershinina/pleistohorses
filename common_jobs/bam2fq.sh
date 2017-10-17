#!/bin/bash

for i in *.bam

do

echo "Converting to fastq: "$i        

bedtools bamtofastq -i $i -fq $i".fq"

done
