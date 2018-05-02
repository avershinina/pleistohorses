# !/usr/bin/python2
# 1 May 2018
# Goal: Convert phastCons wiggle file (with fixed step) to a bed-like file with coordinates.
# Input: PhastCons wiggle:
# fixedStep chrom=chr1 start=6762 step=1
# 0.001
# 0.002
# 0.004

# Output: tabulated file with coordinates and scores.
# 	group	score	start
# 0	6762	0.001	6762
# 1	6762	0.002	6763

# Usage: python2 script.py infile.txt outfile.tab

import numpy as np
import pandas as pd
import re
import sys
infile = sys.argv[1]
outfile = sys.argv[2]
counter=0
with open (infile) as f:
	COORDS = pd.DataFrame()
	for line in f:
		counter += 1
		if 'fixedStep' in line:
			l = re.findall(r"[\w']+", line) # get start coordinate of the current slice and name a group, which equals to a start of the slice.
			counter = 0 # reset counter for the next slice
			continue
		COORDS = COORDS.append(pd.DataFrame({'start': int(l[4])+int(counter)-1, 'score': float(line), 'group': l[4]},index=[0]), ignore_index=True)
	COORDS.to_csv(outfile, sep='\t')
