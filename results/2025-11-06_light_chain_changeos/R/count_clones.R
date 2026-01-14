#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(dplyr))

args <- commandArgs(trailingOnly = TRUE)
CHANGEO_DIR <- args[[1]]
OUT_DIR     <- args[[2]]
locus       <- args[[3]]
SHM_status  <- args[[4]]
functional  <- args[[5]]

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)
changeo <- read.table(file.path(OUT_DIR, paste0("clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")

clone_counts <- changeo %>%
  group_by(sample_id) %>%
  summarize(unique_clones = n_distinct(clone_id), .groups = "drop")

write.table(clone_counts, file.path(OUT_DIR, paste0("clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", quote = FALSE, row.names = FALSE)



