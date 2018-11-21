#!/usr/bin/python
# 21 Nov 2018
# A. Vershinina 
# Goal: create a text file with all possible combinations of three files.
# Useful to run Dstat, fhat, and simmilar stats.
from itertools import permutations 
l = raw_input("Enter a list of genomes in fasta format separated by white space ").split()
combos = []

for comb in permutations(l, 4):
	combos.append(comb)

with open('combos.txt', 'w') as f:
	for c in combos:
		s = " ".join(c)
		f.write(s+"\n")
