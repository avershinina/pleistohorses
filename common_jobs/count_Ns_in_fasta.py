from Bio import SeqIO
import sys
infile = sys.argv[1]
g = SeqIO.parse(infile, "fasta")
bads = []
for s in g:
	n = s.seq.lower().count('n')
	bads.append(n) 
print bads

