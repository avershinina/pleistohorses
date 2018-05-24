#!/usr/bin/python2
# stolen from https://www.biostars.org/p/183279/
# change line 7 to a desired number
import sys
from Bio import SeqIO
for record in SeqIO.parse(sys.argv[1], "fasta"):
    if record.seq.count('N') == 0:
        print(record.format("fasta")
