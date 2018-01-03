# !/usr/bin/python3

# # 30 Dec 2018 - 3 Jan 2018
# # A. Vershinina with some help of https://github.com/AlexKnyshov
# # Goal: incorporate missing data into VCF file.

import numpy as np
import allel; print('scikit-allel', allel.__version__)
import random

vcf = allel.read_vcf('file.vcf.gz')

def convert_to_missing(callset, sampleID, endog):
    '''
    Create an ancient sample in a vcf file.
    The idea here is to take msprime-produced ideal vcf and convert it into a real-life aDNA vcf.
    
        * callset - vcf file in a vcf format. TODO: read hdf5. 
        * sampleID - column # (index) corresponding to a sample of interest.
        NB! Indexing in python starts with 0.
        * endog - proportion of endog DNA (in a format min=0, max=1)
        
    scikit-allele sees missing data as [-1,-1].
    This function takes endog% of interest and outputs a new (permutated) sample that now has a lot of randomly created missing data.
    
    Is it reasonable to create a randomly missing snps to imitate aDNA? Fairly speaking, no. DNA damage is not random. It will differ, for example, in GC-rich regions in comparison to AT rich regions.
    Is it useful to do so? Yes, because it is a simple approach and will serve well for the purpose of this function.
    '''
    
    col = callset['calldata/GT'][:,sampleID] 
    col_name = callset['samples'][sampleID]
    n_snp = col.shape[0] # number of rows in the column, i.e. # of snps
    m = int(round((1-endog) * n_snp)) # If endog content is 70 => 30% of snps will be missing.
    
    print 'Sample name: {}'.format(col_name)
    print 'DNA preservation: {}'.format(endog) # which sample to change
    print 'Missing snips to create: {}'.format(m) # how many snps to change
    
    x = np.copy(col) # this copy is created to avoid wierd numpy behavior. Not sure if I really need this.
    r = random.sample(range(n_snp), m) # create a list with n random values without replacement. This serves as a list of indeces.
    x[r]=  [-1, -1] #replace all elements with indices from *r* list to -1 -1.

    # Sanity check
    test = np.all(x==-1, axis=1)
    m_real = (len(test[test == True]))
    print 'Missing snips created: {}'.format(m_real)
    print 'New array length: {}'.format(len(x))
    return x

Usage:
convert_to_missing(vcf, 200, 0.01)

