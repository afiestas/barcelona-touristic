#!/usr/bin/env Rscript

library(jsonlite)
source("./street_info.R")

f <- file("stdin")
open(f)
all = data.frame()
while(length(line <- readLines(f,n=1)) > 0) {
  streetInfo = strsplit(line, ':')
  streetName = streetInfo[[1]][1]
  streetNum = streetInfo[[1]][2]

  extraInfo <- getStreetInfo(streetName, streetNum)
  all = rbind(all, extraInfo)
  # process line
}

toJSON(all)