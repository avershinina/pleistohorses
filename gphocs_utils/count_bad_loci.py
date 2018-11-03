from Bio import SeqIO
import sys
infile = sys.argv[1]
outfile = sys.argv[2]
g = SeqIO.parse(infile, "fasta")
of = open(outfile, 'w')
bads = []
for s in g:
	n = s.seq.lower().count('n') 
	if n>400: # Change as desired
		bads.append(s.id)

for i in bads:
	of.write("%s\n" % i)
of.close()

