#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Stolen from https://www.biostars.org/p/4881/

import sys
import gzip
from Bio import SeqIO

fasta_file = sys.argv[1]  # Input fasta file
remove_file = sys.argv[2] # Input wanted file, one gene name per line
result_file = sys.argv[3] # Output fasta file

remove = set()
with open(remove_file) as f:
    for line in f:
        line = line.strip()
        if line != "":
            remove.add(line)

# fasta_sequences = SeqIO.parse(open(fasta_file),'fasta')

with open(result_file, "w") as f, gzip.open(fasta_file, "rt") as handle:
    for seq in SeqIO.parse(handle, "fasta"):
    	nam = seq.id
    	nuc = str(seq.seq)
    	if nam not in remove and len(nuc) > 0:
    		SeqIO.write([seq], f, "fasta")
