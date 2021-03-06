#!/usr/bin/R
# 5 April 2018
# A. Vershinina
# Plot distances between features in ONE bed file.
# Import: files with starts and ends of features.
# As we do not need the firts start in the features_start.txt file, I remove the first line from start files. Same for the last line in "ends" file.
# Import to this script is produced by collect_starts_ends.py

#############################
# THIS SCRIPT IS UGLY AS HELL 
# TODO: functions, arguments via conmmand line, etc...
#############################

e_i <- read.csv("ends_inserts.txt", header = F)
s_i <-read.csv("starts_inserts.txt", header = F)
e_d <- read.csv("ends_delets.txt", header = F)
s_d <-read.csv("starts_delets.txt", header = F)
names(s_i) <- "starts"
names(e_i) <- "ends"
names(s_d) <- "starts"
names(e_d) <- "ends"
dists_i <- as.data.frame(s_i-e_i)
names(dists_i) <- "dists_inserts"
dists_d <- as.data.frame(s_d-e_d)
names(dists_d) <- "dists_delets"

png('deletions_300kb_distances_btw_features_histo.png')
hist(dists_d[dists_d$dists_delets>0,], breaks = 1000000, xlim = c(0,300))
dev.off()

png('insertions_100kb_distances_btw_features_histo.png')
hist(dists_i[dists_i$dists_inserts>0,], breaks = 1000000, xlim = c(0,100))
dev.off()

png('insertions_50kb_distances_btw_features_histo.png')
hist(dists_i[dists_i$dists_inserts>0,], breaks = 1000000, xlim = c(0,50))
dev.off()
