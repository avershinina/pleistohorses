# !/usr/bin/python2
# 27 May 2018
# run as: 
# python2 script.py alignment.fasta
# In: fasta alignment
# Out: number of variable sites and sites with Ns.
# This script is initially made to work with "quasi"-alignments made from fasta-loci (like g-phocs loci) concatenated together.  


from Bio import AlignIO
import sys
file = sys.argv[1]
align = AlignIO.read(file, "fasta")
l=align.get_alignment_length()
c=0
N=0
for n in range (l-1):
    s = align[:, n] 
    if s != len(s) * s[0]:
        c = c + 1
    if "N" in s:
        N = N + 1
print ("Total variable sites, including N:",c)
print ("Sites containing N:", N)
