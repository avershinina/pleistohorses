# A. Vershinina
# 29 Aug 2019
# Goal: calculate number of Ns in each sequence in multifasta file
# Usage: python script.py input.multifasta output.name.csv
# Input: multifasta file, output - csv file.
# Output will loook like this:
# seq1, 0
# seq2, 4
# Where number is the number of Ns.

from Bio import SeqIO
import sys
import pandas as pd
infile = sys.argv[1]
outfile = sys.argv[2]
g = SeqIO.parse(infile, "fasta")
final = []
for s in g:
	n = s.seq.lower().count('n')
	final.append([s.name,n]) # this script is not optimized AT ALLL!!!!

with open(outfile, 'wb') as myfile:
    my_df = pd.DataFrame(final)
    my_df.to_csv(myfile, index=False, header=False)
