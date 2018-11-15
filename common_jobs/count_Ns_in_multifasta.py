from Bio import SeqIO
import sys
infile = sys.argv[1]
g = SeqIO.parse(infile, "fasta")
final = []
for s in g:
	n = s.seq.lower().count('n')
	final.append([s.name,n])
print final

