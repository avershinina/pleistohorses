# A. Vershinina
# 27 March 2018
# Goal: collect statistics from BWA flagstat output. 
# This version is collectiong only a number of mapped reads and a number of reads after removing duplicates. 
# It also calculates complexity
# Input: folder with flagstat results
# Output: summary csv file foldername.summary.csv

args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0){
  cat("Syntax: Rscript flagstat.stats.R [path to flagstats files] \n")
  cat("Example: Rscript flagstat.stats.R /flagstat_folder\n")
  quit()
}

filepath_fs=args[1]
files_fs <- list.files(path=filepath_fs, pattern="*.sorted.flagstats.*", full.names=T, recursive=FALSE)
#complexity info
files_RMDUP <- list.files(path=filepath_fs, pattern="*.sorted.rmdup.flagstats.*", full.names=T, recursive=FALSE)

cat ("checking number of found files\n")
if (length(files_fs) == length(files_RMDUP))
{
  cat (paste0("flagstats:", length(files_fs),", files_RMDUP:", length(files_RMDUP), "\n"))
  #create output matrix
  output <- matrix(ncol=4, nrow=length(files_fs))
  #go through each sample
  i = 0
  for (f in files_fs)
  {
    i = i + 1
    #obtain sample name
    filesname <- unlist(strsplit(f, "/"))
    samplename <- unlist(strsplit(unlist(filesname[length(filesname)]), "_"))
    samplen = paste(samplename[1])
    cat(paste0("sample name:", samplen, "\n"))
    #just to make sure on correct pairing of flagstats and seqprep files:
    cat(paste0("flagstats filename:", files_fs[grep(samplen, files_fs)], "\n"))
    cat(paste0("RMDUP filename:", files_RMDUP[grep(samplen, files_RMDUP)], "\n"))
    #look up files with sample name and read them
    flagstat <- read.table(files_fs[grep(samplen, files_fs)], fill = TRUE, header = FALSE, sep = "+")
    rmdup <- read.table(files_RMDUP[grep(samplen, files_RMDUP)], fill = TRUE, header = FALSE, sep = "+")
    #convert flagstats first column to numeric since the last row has chars...
    flagstat$V1 <- as.numeric(as.character(flagstat$V1))
    #same for RMDUP
    rmdup$V1 <- as.numeric(as.character(rmdup$V1))
    AllMapped <- flagstat$V1[3] #corrected to 3
    DedupMap <-  rmdup$V1[3]
    ComplexProp <- DedupMap/AllMapped
    #put results into the matrix
    output[i,] <- c(samplen, AllMapped, DedupMap, ComplexProp)
  }
} else {
  cat ("Error, different number of files/folders found\n")
  quit()
}
output <- data.frame(output)
#label columns
colnames(output) <- c("Sample", "AllMapped", "DedupMap", "ComplexProp")
#write ouput
wd <- basename(getwd())
write.csv(output, file=paste(wd, "summary.csv", sep="."))
cat("done\n")
