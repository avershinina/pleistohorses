# !/usr/bin/python2
# 5 April 2018
# Goal: get positions of ends and starts of features from one BED file. If needed, I can subtract them later.
# Input: regular bed file parsable by pybedtools.
# Output: files with starts and ends.


from pybedtools import BedTool
inserts = BedTool('aGenomes.inserts.bed')
delets = BedTool('aGenomes.delets.bed')


file_s_i = open('starts_inserts.txt', 'w')
file_s_d = open('starts_delets.txt', 'w')
file_e_i = open('ends_inserts.txt', 'w')
file_e_d = open('ends_delets.txt', 'w')


def write_start(targetfile, bedfile):
	for f in bedfile:
		targetfile.write("%s\n" % f.start)
	targetfile.close()

def write_end(targetfile, bedfile):
	for f in bedfile:
		targetfile.write("%s\n" % f.end)
	targetfile.close()


write_start(file_s_i, inserts)
write_start(file_s_d, delets)
write_end(file_e_i, inserts)
write_end(file_e_d, delets)
