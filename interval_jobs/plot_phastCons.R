# 30 April 2018
# A. Vershinina

# this script plots only the first 10kb of the chromosome 
# input file is PhastCons list of probability scores aquired by HMM and n-way alignment of n genomes to a reference.
# example input http://hgdownload-test.cse.ucsc.edu/goldenPath/equCab2/phastCons6way/phastConsScores/
# this script plots only the first 4kb and 300bp of the chromosome 
######
# At! This script is extremely ugly and needs optimization.
######

x <- read.csv2("chr1_all.dat", header = T, nrows=4000)
x$i <- (1:nrow(x)) + 6762 # Change here if using a different chromosome
x2=x[seq(1, nrow(x), 2), ]
x2$bp <- as.numeric(as.character(x2$fixedStep.chrom.chr1.start.6762.step.1))
png("chr1_4kb_2bp_wind_phastcons_track.png", width=1500, height=1000)
par(mar=c(10,6,4,1)+.1)
plot(x2$i, x2$bp, type="l", cex.axis=1, cex.axis=2, main="Probability of a sequence to be a conservative element", cex.main=3, ylab="PhastCons conservation score", cex.lab=2, xlab="position (bp)", lwd=4, cex=1.5)
title(sub="6 way conservation track (hg, mm, canFam, ornAna, galGal)", cex.sub=2, line=8)
dev.off()
###
x <- read.csv2("chr1_all.dat", header = T, nrows=300)
x$i <- (1:nrow(x)) + 6762 # Change here if using a different chromosome
x2=x[seq(1, nrow(x), 2), ]
x2$bp <- as.numeric(as.character(x2$fixedStep.chrom.chr1.start.6762.step.1))
png("chr1_300bp_phastcons_track.png", width=1500, height=1000)
par(mar=c(10,6,4,1)+.1)
plot(x2$i, x2$bp, type="l", cex.axis=1, cex.axis=2, main="Probability of a sequence to be a conservative element", cex.main=3, ylab="PhastCons conservation score", cex.lab=2, xlab="position (bp)", lwd=4, cex=1.5)
title(sub="6 way conservation track (hg, mm, canFam, ornAna, galGal)", cex.sub=2, line=8)
dev.off()
