# !/usr/bin/python2
# 5 June 2018
# A. Vershinina
# Goal: Convert regular .phy file with alignment (aquired with https://github.com/LVRS/fasta_to_phy) into G-PhoCS .phy format
# Input: .phy
# Output: g-phocs phy
# Usage: python script.py infile.phy outfileNAME.phy
import sys
infile = sys.argv[1]
outfile = sys.argv[2]

of = open(outfile, 'w')
locus=[x.strip() for x in file.split('.')][0]
of.write(locus+'\t10' + '\t1000' + '\n')
samples=[]
with open(infile) as f:
    next(f) # need to skip two first lines
    next(f)
    for line in f:
        if "chr1" in line:
            sample=[x.strip() for x in line.split('.')][1]
            of.write("%s\n" % sample)
            #samples.append(sample)
        else:
            of.write(line)
of.close()
