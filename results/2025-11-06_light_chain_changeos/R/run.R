library(readr)
library(dplyr)
library(ggplot2)
library(tidyverse)

CHANGEO_DIR <- ("/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/")

plot_clones < function() {
  changeo_IGK <- read.csv(paste0(CHANGEO_DIR, "IGK", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')
  changeo_IGL <- read.csv(paste0(CHANGEO_DIR, "IGL", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')

  for (changeo in c(changeo_IGK, changeo_IGL)) {
    clone_counts <- changeo %>% group_by(sample_id) %>% summarize(unique_clones = n_distinct(sequence_aa))
    ggplot(clone_counts, aes(x="", y=unique_clones)) +
      geom_boxplot()
  }
}
plot_clones()
