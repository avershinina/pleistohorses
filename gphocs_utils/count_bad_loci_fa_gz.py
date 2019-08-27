from Bio import SeqIO
import gzip
import sys
infile = sys.argv[1]
outfile = sys.argv[2]
of = open(outfile, 'w')
bads = []
with gzip.open(infile, "rt") as handle: # if fasta is gzipped
	for s in SeqIO.parse(handle, "fasta"):
		n = s.seq.lower().count('n') 
		if n>200: # change as desiered
			bads.append(s.id)

for i in bads:
	of.write("%s\n" % i)
of.close()
