# GPhoCS pipeline
1. Collect BED files of putatively  neutral regions.
2. Convert BAM alignments into fasta files (for example - using ANGSD). 
3. Ascertain a set of neutral loci (in a form of a new bed file) using information from BED files.
4. Use bedtools to collect loci in fasta format
5. Filter and characterize collected neutral loci (accounting for amount of missing data).
6. Finalize the set of putatively neutral loci.
7. Convert these loci into gphocs phylip format.
8. Create gphocs config file to run the program.
9. Run GPhoCS!
