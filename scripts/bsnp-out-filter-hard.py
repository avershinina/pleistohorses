# !/usr/bin/python3
# 5 Oct 2017
# run as: 
# python3 filter.py BSNP-out.snp 20 0.98 5
import csv
import sys
import pandas as pd
 
# csv file name ana filter parameters
filename = sys.argv[1]
min_MAQcallQ = float(sys.argv[2]) 
min_Poster_Prob = float(sys.argv[3]) 
min_num_good_reads = float(sys.argv[4])
filenameout = sys.argv[1].replace('.snp', '_Q.filtered.snp')

# ?filter out transitions to leave transversions  
# Ts A-G C-T
# Tv A-C A-T G-C G-T


# initializing the titles and rows list
fields = []
chunksize =100000 # for pandas to read output in chunks, play with this parameter

# reading csv file
with open(filename, 'r') as tsvin, open (filenameout, 'w') as tsvout:
  write_header=True
  for df in pd.read_csv(tsvin, delimiter='\t', quoting=csv.QUOTE_NONE, chunksize=chunksize, iterator=True):
    filtered_df = df[(df.MAQcallQ>=min_MAQcallQ) & (df.NumGoodReads>min_num_good_reads)]
    filtered_df = filtered_df[(filtered_df['P(G=AA)']>min_Poster_Prob) | (filtered_df['P(G=AC)']>min_Poster_Prob) | (filtered_df['P(G=AG)']>min_Poster_Prob) | (filtered_df['P(G=AT)']>min_Poster_Prob) | (filtered_df['P(G=CC)']>min_Poster_Prob) | (filtered_df['P(G=CG)']>min_Poster_Prob) | (filtered_df['P(G=CT)']>min_Poster_Prob) | (filtered_df['P(G=GG)']>min_Poster_Prob) | (filtered_df['P(G=GT)']>min_Poster_Prob) | (filtered_df['P(G=TT)']>min_Poster_Prob)]
	#& (df.ix[:,8]>=min_Poster_Prob) & (df.NumGoodReads>min_num_good_reads)]
    if write_header is True:
      filtered_df.to_csv(tsvout, sep='\t', mode='a', index=False, header=True)
      write_header=False
    else:
      filtered_df.to_csv(tsvout, sep='\t', mode='a', index=False, header=False)
