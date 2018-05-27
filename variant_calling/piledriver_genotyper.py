# !/usr/bin/python3
# 24 May 2018
# run as: 
# python2 piledriver_genotyper.py piledriver.gz
# At! This script is extremely ugly and needs many functions.

import csv
import sys
import pandas as pd
 
# csv file name
file = sys.argv[1]
filenameout = sys.argv[1].replace('.gz', '.genotyped.gz')

chunksize =10**6 # for pandas to read output in chunks, play with this parameter
header=['chrom','start','end','ref','depth','r_depth','a_depth','num_A','num_C','num_G','num_T','num_D','num_I','totQ_A','totQ_C','totQ_G','totQ_T','all_ins','num_F_A','num_F_C','num_F_G','num_F_T','num_F_D','num_F_I','totQ_F_A','totQ_F_C','totQ_F_G','totQ_F_T','all_F_ins','num_R_A','num_R_C','num_R_G','num_R_T','num_R_D','num_R_I','totQ_R_A','totQ_R_C','totQ_R_G','totQ_R_T','all_R_ins', 'sample_1', 'sample_2', 'sample_3', 'sample_4']

# reading csv file
for p in pd.read_csv(file, sep='\t', header=None, names=header, chunksize=chunksize, compression="gzip"):
	p['alleles']=4-p[['num_A','num_C','num_G','num_T']].apply( lambda s: s.value_counts().get(0,0), axis=1)
	pile = p.query('alleles=2').copy()
	pile.loc[(pile.num_A>0), 'gt1'] = 'A' # TODO: function this
	pile.loc[(pile.num_C>0), 'gt2'] = 'C'
	pile.loc[(pile.num_G>0), 'gt3'] = 'G'
	pile.loc[(pile.num_T>0), 'gt4'] = 'T'
	pile['GT']=pile['gt1'].fillna('') + pile['gt2'].fillna('')+ pile['gt3'].fillna('')+ pile['gt4'].fillna('')
	pile.loc[(pile.GT=="AG"), 'GT_type'] = 'Ti' # TODO: function this too
	pile.loc[(pile.GT=="AG"), 'GT_type'] = 'Ti'
	pile.loc[(pile.GT=="CT"), 'GT_type'] = 'Ti'
	pile.loc[(pile.GT=="TC"), 'GT_type'] = 'Ti'
	pile.loc[(pile.GT=="AC"), 'GT_type'] = 'Tv' # TODO: funtion this as well
	pile.loc[(pile.GT=="CA"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="AT"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="TA"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="CG"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="GC"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="GT"), 'GT_type'] = 'Tv'
	pile.loc[(pile.GT=="TG"), 'GT_type'] = 'Tv'
	pile.to_csv(filenameout, sep='\t', mode='w', index=False, header=False, compression='gzip')
