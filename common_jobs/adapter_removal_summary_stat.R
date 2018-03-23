files <- list.files(path="/reads/", pattern="*.trim.settings*", full.names=T, recursive=FALSE)
output <- matrix(ncol=4, nrow=length(files))
i=0
for (f in files)
{
  i = i + 1
  # sample names
  filesname <- unlist(strsplit(f, "/"))
  samplename <- unlist(strsplit(unlist(filesname[length(filesname)]), ".trim"))
  samplen <- samplename[1]
  cat(paste0("sample name:", samplen, "\n"))
  s <- read.table(files[grep(samplen, files)], fill=TRUE, header = FALSE, sep = ":")
  s$V2 <- as.numeric(as.character(s$V2))
  r_total <- s$V2[22]
  r_retained <- s$V2[29]
  r_proc <- r_retained / r_total * 100
  output[i,] <- c(samplen, r_total, r_retained, r_proc)
}
output <- data.frame(output)
colnames(output) <- c("sample", "reads_total", "reads_reatined", "prop_retained")
write.csv(output, file="trimming_summary.csv")
