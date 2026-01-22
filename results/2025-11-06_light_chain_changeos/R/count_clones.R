#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(dplyr))
MODE <- commandArgs(trailingOnly = TRUE)[[1]]
CHANGEO <- commandArgs(trailingOnly = TRUE)[[2]]
OUT_TSV <- commandArgs(trailingOnly = TRUE)[[3]]

count_distinct <- function() {
  changeo <- read.table(file.path(CHANGEO), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
  
  clone_counts <- changeo %>%
    group_by(sample_id) %>%
    summarize(unique_clones = n_distinct(paste(v_call, j_call, junction, sep = "|")), .groups = "drop")
  
  write.table(clone_counts, file.path(OUT_TSV), sep = "\t", quote = FALSE, row.names = FALSE)
}

count_all_clones_per_sample <- function() {
  changeo <- read.table(file.path(CHANGEO), sep = "\t", header = TRUE, 
                        stringsAsFactors = FALSE, quote = "", comment.char = "")
  
  clone_counts <- changeo %>%
    group_by(sample_id) %>%
    summarize(total_clones = n(), .groups = "drop")
  
  print(clone_counts)
  write.table(clone_counts, file.path(OUT_TSV), sep = "\t", 
              quote = FALSE, row.names = FALSE)
}

count_all_clones <- function() {
  changeo <- read.table(file.path(CHANGEO), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
  
  clone_counts <- data.frame(clones = nrow(changeo))
  
  print(clone_counts)
  write.table(clone_counts, file.path(OUT_TSV), sep = "\t", quote = FALSE, row.names = FALSE)
}

if (MODE == "distinct") {
  count_distinct()
} else if (MODE == "all_per_sample") {
  count_all_clones_per_sample()
} else if (MODE == "all") {
  print("counting")
  count_all_clones()
}