# !/usr/bin/python
# 11 Oct 2017
# created together with https://github.com/AlexKnyshov
# this script filters out regions from GFF file
# made specifically for ref_gene records, so DON'T FORGET TO CHANGE LEN OF FLANKING REGIONS
# usage: script.py in.bed in.csv 
# 

import csv
import sys

filename1 = sys.argv[1] # bed file with regions to filter out
filename2 = sys.argv[2] # csv file to clean up
filenameout = sys.argv[2].replace('.Q.trf.rpt.mskr.filtered.snp', '.Q.trf.rpt.mskr.refgene.filtered.snp')

#initialize regions
startlist = {} #startlist =[]
endlist = {} #endlist=[]
fields=[]
#chrnum=[]

# read the bed file
with open(filename1, 'rb') as bedin:
	bedin = csv.reader(bedin, delimiter='\t')
	#next(bedin)
	for row in bedin:
		if row[0] not in startlist:
			startlist[row[0]] =[row[3]]
		else:
			startlist[row[0]].append(row[3])
		if row[0] not in endlist:
			endlist[row[0]] = [row[4]]
		else:
			endlist[row[0]].append(row[4])
	#print(startlist)

	#chrnum.append(row[0])
	#dict start
	#dict end
	#chrnum - key for dict
	#values in dicts are lists
	#write in lists start and end

with open(filename2, 'r') as csvin, open(filenameout, 'w') as csvout:
	csvin = csv.reader(csvin, delimiter='\t')
	csvout = csv.writer(csvout, delimiter='\t')

	# extracting field names through first row
	fields = csvin.next()
	csvout.writerow(fields)
	for row in csvin:
		keep=True
		if row[0] in startlist:
			#print (row[0])
			for x in range(0,len(startlist[row[0]])):
				#print int(startlist[row[0]][x]), int(row[1]), int(endlist[row[0]][x])
				if int(int(startlist[row[0]][x])-1000)<=int(row[1])<=(int(endlist[row[0]][x])+1000): #and chrnum[x]==row[0]: # flanking regions 1kb
					keep=False
					print "snp in a repeat found!"
					break
			if keep:
				csvout.writerow(row)
		else:
			csvout.writerow(row)
