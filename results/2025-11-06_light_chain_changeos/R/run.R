library(tidyverse)

CHANGEO_DIR <- ("/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/")

plot_clones < function() {
  changeo_IGK <- read.csv(paste0(CHANGEO_DIR, "IGK", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')
  changeo_IGL <- read.csv(paste0(CHANGEO_DIR, "IGL", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')

  for (changeo in list(changeo_IGK, changeo_IGL)) {
  clone_counts <- changeo %>% group_by(.data[["sample_id"]]) %>% summarize(unique_clones = n_distinct(clone_id))
  p <- ggplot(clone_counts, aes(x="", y=unique_clones)) +
    geom_boxplot(outlier.shape=NA) + 
    labs(title = paste0("Clone counts for ", changeo$locus[[1]], "")) +
    geom_jitter(width=0.1, size = 2) +
    theme_minimal() +
    labs(x="Samples", y="Number of unique clones") +
  print(p)
}
}


plot_clones()
