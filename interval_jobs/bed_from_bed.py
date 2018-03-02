# !/usr/bin/python3
# 1 March 2018
# A. Vershinina together with https://github.com/AlexKnyshov

# Goal: having a known CONST length of regions of interest (say 1kb) and a step (say 30kb), create a set of coordinates (in BED format) using another .bed file as a guide.
# This particular version implies that BED coordinats tell us where the regions should be. Example: if .bed file:
# chr1	4	35000	feature1
# chr1	40000	43000	feature2
# chr1	100000	220000	feature3
# Region of interest is 1kb and step is 30kb, the output:
# [[4, 1004], [31005, 32005], [100000, 101000], [131001, 132001], [162002, 163002], [193003, 194003]]
#######
# NB! This script works only if step > region. 
# I do no not know how it beahaves if intervals between features are < region length.
#######
# Important details about BED coordinates
# * chromStart - The starting position of the feature in the chromosome or scaffold. The first base in a chromosome is numbered 0.  
# * chromEnd - The ending position of the feature in the chromosome or scaffold. The chromEnd base is not included in the display of the feature. For example, the first 100 bases of a chromosome are defined as chromStart=0, chromEnd=100, and span the bases numbered 0-99.
# b - bed file
# a - array
# l - length
# f - feature
# r - region
# s - step
# c - coordinate

import pybedtools
import numpy as np
import argparse # TODO: need command line input here

b = pybedtools.BedTool('Documents/projects/sandbox/intervals.bed')

b_l = len(b)
start_1st_f=b[0].start
end_last_f=b[b_l-1].end


r = 1000
s = 30000 + r + 1 # desired step + region + 1

def extract_region(start, end, array):
    ''' Extract coordinates of a region knowing two coordinates. Output - an array with coordinates. '''
    a_temp = [start, end]
    array.append(a_temp)
    return array
    
def jump_to_next_interval(bedfile, iterator):
    ''' Update while-loop iterator based on a condition. In this case condition is checking where is the nearest usable feature. Output - increment for an iterator''' 
    dists = []
    for feature in bedfile:
        dist = feature.start - iterator
        if dist > 0:
            dists.append(dist)
    m = min(dists)
    return m       

COORDs=[] # empty list init
i = start_1st_f # start from the first usable feature
while i < end_last_f:
    start_c = i
    end_c = start_c + r # !NB! BED coordinates do not include the last bp (0 _ 100 is 0-99). Stop coordinate in the output will be 1 bp longer than the desired region length. Let's say you want it to be 3 bp long, starting from 4. Output will be 4-7, i.e. 4,5,6, and 7.   
    ok = False
    for f in b:
        if start_c >= f.start and end_c <= f.end:
            ok = True
            break
    if ok:
        COORDs = extract_region(start_c, end_c, COORDs)
        i = i + s
    else:
        m = jump_to_next_interval(b, i)
        i = i + m
print COORDs
# TODO: finalize bed, make iteration by chromosomes
