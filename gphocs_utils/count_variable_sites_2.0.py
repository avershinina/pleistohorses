# 10 Dec 2020
# run as: 
# python3.8 script.py alignment.fasta
# In: fasta alignment
# Out: number of variable
# This script is initially made to work with "quasi"-alignments made from fasta-loci (like g-phocs loci) concatenated together.  


from Bio import AlignIO
import sys
file = sys.argv[1]
align = AlignIO.read(file, "fasta")
l=align.get_alignment_length()
c=0
N=0
for n in range (l-1):
# for n in range (3207128,3207150):
    s = align[:, n] 
    s = s.replace("N","")
    setS = set(s)
    lenS = len(setS)
    if lenS > 1:
        c = c + 1
#    print(len(s) * s[0])

#    if s != len(s) * s[0]:
#        c = c + 1
 #   if "N" in s:
 #       N = N + 1
#    print(c)
print ("Total variable sites (if N is the only difference - the site is not considered variable):",c)
#print ("Sites containing N:", N)
