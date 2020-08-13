# Evolution and extinction of caballine horses in Ice Age Beringia
[![NSF-1417036(https://img.shields.io/badge/NSF-1417036-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1417036)
   
   
This NSF-supported collaborative project (award # 1417036) looks into the past to inform the future. 
This study asks: How important was connectivity among populations of large arctic mammal species for maintaining genetic diversity, influencing evolutionary change, and mitigating extinction risk? What types of barriers affected this connectivity, and how permeable were these barriers to gene flow? This study looks into how caballine horses, that inhabited ice-age Beringia (the biogeographic connector between Asia and North America), were affected by changes involving three different biogeographic barriers/corridors (1. the Bering Strait/Bering Land Bridge, which controlled dispersal and gene flow between Eurasia and Alaska; 2. the Ice-Free Corridor, which controlled gene flow between the Yukon and the Lower 48 States; and 3. biome shifts that periodically disrupted the spatial continuity of the Mammoth-Steppe, the unique ecosystem that stretched from France to the Yukon during the ice ages) during the last 30,000 years of the ice age.

## Computational analysis
Pipeline:
* genotype calling on high coverage genomes using three programs (AntCaller, Samtools, and GATK);
* intersection of genotype calls to get the final set of genotypes found by all three callers (/variant_calling);
* simulation of genotypes using msprime (/fake_snp_panel);
* finding specific regions of the genome using various filters (/interval_jobs);
* admixture estimates (/admixture_utils);
* demographic reconstruction (/gphocs_utils)

# Additional data

Some [data](http://geogenetics.ku.dk/publications/middle-pleistocene-omics) from 2005 paper published by Orlando lab.

# a horse in ASCII

```
             ._ _ .
           ""\_`-)|_
       /,""         \ 
     //," ##  (*> (*>. 
  ///,|"#   ,- \_     `.
////,""    /     `--._  )
," |# 	  /
```

