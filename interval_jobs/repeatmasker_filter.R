# !/usr/bin/R
# 28 April 2018
# This script takes data downloaded from http://www.repeatmasker.org
# This is a table with headers. 
# It filters out for -div option, removes "low complexity" and "simple repeat" entries, takes a chromosome you desire, and finally exports 2 files:
# file with a short info about repeats
# bed file of filtered repeats
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0){
  cat("Syntax: Rscript [script.R] [rptmsk.txt] [divergence] [chrom]\n")
  cat("Example: Rscript [script.R] rptmsk.txt 20 chr1 \n")
  quit()
}
r <- read.table(args[1], header = F, skip=2)
h <- c("SW", "div","del", "ins", "seq", "start", "end", "left", "strand", "name","class", "pos_begin", "pos_end", "pos_left", "ID")
names(r) <- h
chr <- subset(r, div<args[2] & seq==args[3] & class!="Low_complexity" & class !="Simple_repeat", select=c(SW, div, seq, start, end, strand, name, class,ID))
bed <- subset(chr, select=c(seq, start, end))
message("You selected ", nrow(chr), " repeats")

write.csv(chr, file=paste(args[3], ".div.", args[2], ".rmsk.info"))
write.table(bed, sep="\t", file=paste(args[3], ".div.", args[2], ".rmsk.bed"))
cat("done\n")
