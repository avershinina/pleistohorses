
# coding: utf-8

# # 13-14 Dec 2017
# ### A. Vershinina
# ### Goal: retrieve PSMC data and convert it into msprime-readable format
# 
# 
# 

# ## Import packages and specify constant variables

# In[1]:


from __future__ import print_function
import sys
import numpy as np
import sys
import math


# In[12]:


g = 5 # generation time


# ## Import psmc data
# Run plot_psmc.pl saving temporary files.  
# Import temporary files.  
# We do not believe Ne retrieved for time period that is younger than our samples, so in A we skip 5 lines and in B we skip two.

# In[162]:


A_psmc = np.genfromtxt("/A.5y.plot.0.txt", skip_header=5)
B_psmc = np.genfromtxt("/B.5y.plot.1.txt", skip_header=2)


# ## Function to convert geological time to generations and Ne to Ne*10^4

# In[168]:


def psmc2trace(psmc,gen_time):
    t = psmc[:,0]/gen_time # time in generations
    n = psmc[:,1]*10**4 # effective pop size, scaled to 1e4 
    return zip(t, n)


# ## Convert and scale psmc demography

# In[174]:


A_trace = psmc2trace(A_psmc, g)
B_trace = psmc2trace(B_psmc, g)


# ## Record msprime config parameters

# In[176]:


for a,b in A_trace:
    print (
        "    msprime.PopulationParametersChange(time={}, initial_size={}, growth_rate = 0, population_id=0),".format(a,b),
        file = open("msprime_config_A.txt", "a"))
for a,b in B_trace:
    print (
        "    msprime.PopulationParametersChange(time={}, initial_size={}, growth_rate = 0, population_id=1),".format(a,b),
        file = open("msprime_config_B.txt", "a") )

