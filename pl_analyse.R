#!/usr/bin/env Rscript
rm(list = ls())
gc()

genome_name <- c("SmikMEGA", "SkudMEGA", "SbayMEGA", "SarbMEGA", "ScerMEGA", "SparMEGA")

svg("TRUC.svg");
par(mfrow = c(3, 2), mai = rep(0.25, 4))

library(RColorBrewer)

data_cds <- read.table(paste("output_cds/SmikMEGA_vs_SkudMEGA_cds.txt", sep = ""))
View(head(data_cds))

color = 1

for(i in genome_name){

    plot(NULL, xlim= c(1,4), ylim = c(0, 2), main = i)

    for(j in genome_name){

    data_cds <- read.table(paste("output_cds/", i, "_vs_", j, "_cds.txt", sep = ""))
    points(density(log10(data_cds$V5), na.rm = T), col = color, type = "l")

    data_igorf <- read.table(paste("output_igorf/", i, "_vs_", j, "_orf.txt", sep = ""))
    points(density(log10(data_igorf$V5), na.rm = T), col = color, type = "l")
    color = color + 1
  }
}
dev.off()