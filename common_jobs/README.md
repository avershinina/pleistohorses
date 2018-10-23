- [Working with raw data](#working-with-raw-data)
  * [Collect statistics](#collect-statistics)
  * [Mapping](#mapping)
  * [Format convertion](#convertion)
- [Calculate and collect statistics](#calculate-and-collect-statistics)
  * [VCF](#vcf)
  * [BAM](#bam)
- [Tidy up the data](#tidy-up-the-data)
- [Misc](#misc)

# Working with raw data
## Collect statistics
* count_reads_SE_fastq.sh  
* adapter_removal_summary_stat.R 

## Mapping
* add_RG_indel_realign_MD_recal.sh 
* index-bam-files.sh
* sort-index-bams.sh
## Format convertion
* bam2fq.sh
* bam2fasta.sh - using ANGSD converts BAM to fasta using IUPAC codes with a treshold for het conversion. 

# Calculate and collect statistics
## VCF
* calculate_pi_on_multisample_vcf.sh 
## BAM
*	coverage_stats_from_bam.R
* flagstat_collect_stats.R
* idxstat_collect_stats.R  


# Tidy up the data
* run_AdapterRemoval_then_FastQC.sh
* clean-bam-from-chr.sh 
* downsample_fastq_with_seqtk.sh 

# Misc 
* grep-many-files-using-OR.sh 
* run_smth_recursively.sh  

