from Bio import SeqIO
import sys
import pandas as pd
infile = sys.argv[1]
outfile = sys.argv[2]
g = SeqIO.parse(infile, "fasta")
final = []
for s in g:
	n = s.seq.lower().count('n')
	final.append([s.name,n])

with open(outfile, 'wb') as myfile:
    my_df = pd.DataFrame(final)
    my_df.to_csv(myfile, index=False, header=False)