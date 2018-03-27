# A. Vershinina
# 27 March 2018
# Goal: collect statistics from BWA indexstat output. 
# This version is collecting only a number of mapped reads on chr 1,2 and 3. 
# Input: folder with idxstat results
# Output: summary csv file foldername.chr1-2-3-idxstats.csv
# Usage: Rscript collect_stats.R /path/folder/name

args = commandArgs(trailingOnly=TRUE)
filepathidx=args[1]

filesidx <- list.files(path=filepathidx, pattern="*.rmdup.idxstats*", full.names=T, recursive=FALSE)
datalist=list()
#go through each sample
i = 0
for (f in filesidx)
{
  i = i + 1
  idx <- read.csv(f, sep = '\t', header = F)
  idx <- idx[(idx$V1=="chr1" | idx$V1=="chr2" | idx$V1=="chr3"),] # Change here to get other chromosomes 
  samplename <- strsplit(f, '[/]')[[1]]
  l <- length(samplename)
  samplen <- strsplit(samplename, '[.]')[[l]][1]
  idx[5] <- samplen
  names(idx) <- c("chr", "ref_len", "mapped_reads", "unmapped_reads", "sample")
  datalist[[i]] <- idx
}

output <- do.call(rbind, datalist)
wd <- basename(getwd())
write.csv(output, file=paste(wd, "chr1-2-3-idxstats.csv", sep="."))
#write.table(utms, file=paste(x, ".mean", sep=""))
cat("done\n")
