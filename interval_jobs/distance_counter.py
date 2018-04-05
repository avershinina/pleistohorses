# !/usr/bin/python3
# 4 April 2018
# Goal: calculate distances between features in bed file
# Input: regular bed file parsable by pybedtools
# Output: file with distance between 
################
# this is ugly and not working
################
from pybedtools import BedTool
inserts = BedTool('aGenomes.inserts.bed')
delets = BedTool('aGenomes.delets.bed')
dists_ins = []

def subtract(bedfile):
	dists=[]
	features = (bedfile).count()
	counter = features-1
	for i in range (counter):
		dists.append(bedfile[i+1].start-bedfile[i].end+1)
	return dists

d_i = subtract(inserts)
d_d = subtract(delets)

file_insert = open('insert_dists.txt', 'w')
file_delet = open('delet_dists.txt', 'w')

for item in d_i:
	file_insert.write("%s\n" % item)
file_insert.close()

for item in d_d:
	file_delet.write("%s\n" % item)
file_delet.close()
