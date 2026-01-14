#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(dplyr))

CHANGEO <- commandArgs(trailingOnly = TRUE)[[1]]
OUT_TSV <- commandArgs(trailingOnly = TRUE)[[2]]

changeo <- read.table(file.path(CHANGEO), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")

clone_counts <- changeo %>%
  group_by(sample_id) %>%
  summarize(unique_clones = n_distinct(paste(v_call, j_call, junction, sep = "|")), .groups = "drop")

write.table(clone_counts, file.path(OUT_TSV), sep = "\t", quote = FALSE, row.names = FALSE)
