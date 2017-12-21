#!/usr/bin/python2
# coding: utf-8

# # 14 Dec 2017
# ### A. Vershinina
# ### Goal: generate SNPs following a specific demographic scenario. 
# Let's start easy: only chromosome 1
# Inspired by
# https://github.com/armartin/ancestry_pipeline/blob/a0e6873a5f0201e8d72588365562d63a73cf2751/simulate_prs.py
# 
# ## Config parameters (samples, migration matrix, demo events) are storewd in a separate module


# import all necessary packages
from __future__ import print_function # probably don't need this since it is python2.7
import sys
import math
import argparse
from datetime import datetime
import gzip
import os 
# import config file, msprime module is there
from msprime_universal_config import *

def eprint(*args, **kwargs): # Stolen https://github.com/armartin/ancestry_pipeline/blob/a0e6873a5f0201e8d72588365562d63a73cf2751/simulate_prs.py
    print(*args, file=sys.stderr, **kwargs)

def current_time(): # Also stolen
    return(' [' + datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S') + ']')


def out_of_NA (locus, r_rate, mut_rate, pop_config, demography, mm, samples):
    """
    take parameters from msprime_universal_config
    return results of the simulation (tree sequence)
    """
    eprint('Starting simulations' + current_time())

    TS = msprime.simulate(
        Ne = N_ANC, # constant param
        length=locus, 
        recombination_rate=r_rate, 
        mutation_rate=mut_rate, 
        population_configurations=pop_config,
        demographic_events=demography, 
        migration_matrix=mm, 
        samples=samples)
    eprint('Ending simulations' + current_time())
    return TS


def create_vcf (TS, locusname): # should make it bgzip, not gzip, and then tabix immediately.
    with gzip.open(locusname + '_out_of_NA_nhaps_' + '_'.join(map(str, nhaps)) + '.vcf.gz', "wb") as vcf_file:
        TS.write_vcf(vcf_file, 2)

def main(args): # TODO: out_of_NA seems redundant  
    """
    generate/load coalescent simulations
    """
    locus = args.LocusLen
    if args.tree is None:
        simulation = out_of_NA(
            locus=locus,  
            mut_rate=u, 
            r_rate=r, 
            demography=demographic_events, 
            mm=migration_matrix, 
            pop_config=population_configurations, 
            samples = samples
            )
        simulation.dump(args.LocusName + '_TS_out_of_NA_nhaps_' + '_'.join(map(str, nhaps)) + '.hdf5', True)
        create_vcf(simulation, LocusName)
    else:
        simulation = msprime.load(args.tree)
    
    print
    eprint(simulation)
    eprint('Number of modern haplotypes, Pr first and Dom second: ' + ','.join(map(str, nhaps)))
    eprint('Number of trees: ' + str(simulation.get_num_trees()))
    eprint('Number of mutations: ' + str(simulation.get_num_mutations()))
    eprint('Sequence length: ' + str(simulation.get_sequence_length()))

def debug_ms (N_ANC, pop_config_debug, mm, demography):
    debug = msprime.DemographyDebugger(
        Ne=N_ANC,
        population_configurations = pop_config_debug,
        migration_matrix = mm,
        demographic_events = demography)
    return debug.print_history()    


# debug_ms(100, population_configurations_debug, migration_matrix, demographic_events)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--tree')
    parser.add_argument('--LocusLen', type=int, default=1000)
    parser.add_argument('--LocusName', default='test')
    args = parser.parse_args()
    main(args)


