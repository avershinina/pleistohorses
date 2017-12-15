# python3
# 15 Dec 2017
# A. Vershinina
# Goal: generate msprime "samples" config
# imitating a number of ancient samples 
# having different radiocarbon ages.

# import all necessary packages
from __future__ import print_function
import random

def generate_years(youngest_date, oldest_date, nsamples):
    """
    generate a list of dates - imitate a number (=nsamples) of paleo samples
    """
    years = random.sample(range(youngest_date, oldest_date), nsamples)
    return years
    
def years2samples(years, gen_time, pop_id):
    """
    generate msprime sample list 
    convert time points to generations,
    pop_id - for which population to generate config parameters
    """
    generations = list(map(lambda x: x/gen_time, years))
    N = [int(pop_id)] * len(generations)
    return zip(N, generations)
    
y = generate_years(10,100, 5)
fossils = years2samples(y, 5, 0)
for pop_id, t in fossils:
    # msprime generates haploids, so we need 2 haplotypes for each time point
    print (
        "[msprime.Sample(population={}, time={}) for _ in range(2)] +".format(pop_id, t), 
        file = open("msprime_samples.txt", "a"))
