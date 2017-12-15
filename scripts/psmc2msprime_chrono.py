
# coding: utf-8

# # 13-14 Dec 2017
# ### A. Vershinina
# ### Goal: retrieve PSMC data and convert it into msprime-readable format
# Here config is created with events sorted chronologically.

# ## Import packages and specify constant variables

# In[2]:


from __future__ import print_function
import sys
import numpy as np
import sys
import math


# In[3]:


g = 5 # generation time


# ## Import psmc data
# Run plot_psmc.pl with -R indicator to save temporary files.  
# Import temporary files.  
# We do not believe Ne retrieved for time period that is younger than our samples, so in A we skip 5 lines and in B we skip two.

# In[6]:


A_psmc = np.genfromtxt("/A.5y.plot.0.txt", skip_header=5)
B_psmc = np.genfromtxt("/B.5y.plot.1.txt", skip_header=2)


# ## Function to convert geological time to generations and Ne to Ne*10^4

# In[38]:


def psmc2trace(psmc,gen_time,pop_id):
    t = psmc[:,0]/gen_time # time in generations
    n = psmc[:,1]*10**4 # effective pop size, scaled to 1e4
    N = [int(pop_id)] * len(A_trace)
    return zip(t, n, N)


# ## Convert and scale psmc demography

# In[41]:


A_trace = psmc2trace(A_psmc, g, 0)
B_trace = psmc2trace(B_psmc, g,1)


# ## Record msprime config parameters

# In[45]:


combined_scenarios = sorted(A_trace+B_trace)


# In[46]:


for t,n, pop_id in combined_scenarios:
    print (
        "    msprime.PopulationParametersChange(time={}, initial_size={}, growth_rate = 0, population_id={}),".format(t,n, pop_id),
        file = open("msprime_config.txt", "a"))

