#!/usr/bin/python
# 4 Nov 2018
# A. Vershinina
# Goal: convert fasta of neutral regions to something resembling phylip

from Bio import SeqIO

r1 = SeqIO.parse("g1.fa", "fasta") # add filenames of the genomes
r2 = SeqIO.index("g2.fa", "fasta")
r3 = SeqIO.index("g3.fa", "fasta")
r4 = SeqIO.index("g4.fa", "fasta") 
r5 = SeqIO.index("g5.fa", "fasta")
r6 = SeqIO.index("g6.fa", "fasta")
r7 = SeqIO.index("g7.fa", "fasta")
r8 = SeqIO.index("g8.fa", "fasta")


for r in r1:
	print r.id+'\t8' + '\t1000' # change accordingly to the number of genmes (example - 8) and length of the locus (1000bp)
	print 'kd850'+'\t'+r.seq # change accordingly your desiered name of the sample in the final gphocs run
	print 'Bata'+'\t'+ r2[r.id].seq
	print 'sib022'+'\t'+ r3[r.id].seq
	print 'nW'+'\t'+ r4[r.id].seq
	print 'MSJK'+'\t'+ r5[r.id].seq
	print 'P'+'\t'+ r6[r.id].seq
	print 'S'+'\t'+ r7[r.id].seq
	print 'T'+'\t'+ r8[r.id].seq + '\n'

