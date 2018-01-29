# !/usr/bin/python
# 11 Oct 2017
# created together with https://github.com/AlexKnyshov
# this script filters out regions from BED file
# usage: script.py in.bed in.csv 
# 

import csv
import sys

filename1 = sys.argv[1] # bed file with regions to filter out
filename2 = sys.argv[2] # csv file to clean up
filenameout = sys.argv[2].replace('.Q.filtered.snp', '.Q.trf.filtered.snp')

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
			startlist[row[0]] =[row[1]]
		else:
			startlist[row[0]].append(row[1])
		if row[0] not in endlist:
			endlist[row[0]] = [row[2]]
		else:
			endlist[row[0]].append(row[2])
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
				if int(startlist[row[0]][x])<=int(row[1])<=int(endlist[row[0]][x]): #and chrnum[x]==row[0]: 
					keep=False
					print "snp in a repeat found!"
					break
			if keep:
				csvout.writerow(row)
		else:
			csvout.writerow(row)
